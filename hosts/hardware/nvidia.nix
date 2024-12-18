{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.hardware.nvidia-gpu;
in {
  options.hardware.nvidia-gpu.enable = mkEnableOption "Enable nvidia-gpu";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nvtopPackages.full
      autoAddDriverRunpath
      nvidia-vaapi-driver
      egl-wayland
    ];

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = ["nvidia"];
    boot.kernelParams = [
      "nvidia-drm.fbdev=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];

    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;
      # Allow headless mode
      nvidiaPersistenced = false;

      powerManagement.enable = false;
      powerManagement.finegrained = false;
      dynamicBoost.enable = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.latest;

      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";

        # Offload Mode, primary using integrated GPU
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        # Sync Mode, primary using discrete GPU
        # sync = {
        #   enable = true;
        # };
      };
    };
  };
}
