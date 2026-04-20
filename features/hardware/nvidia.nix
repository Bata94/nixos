{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.hardware.nvidia-gpu;
in {
  options.features.hardware.nvidia-gpu.enable = mkEnableOption "Enable nvidia-gpu";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nvtopPackages.full
      autoAddDriverRunpath
      nvidia-vaapi-driver
      egl-wayland
      nvidia-container-toolkit
    ];

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = ["modesetting" "nvidia"];
    boot.kernelParams = [
      "nvidia-drm.fbdev=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];

    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;
      # Allow headless mode
      nvidiaPersistenced = false;

      powerManagement.enable = true;
      powerManagement.finegrained = true;
      dynamicBoost.enable = true;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = true;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      # package = config.boot.kernelPackages.nvidiaPackages.latest;
      # Apply CachyOS kernel 6.19 patch to NVIDIA latest driver
      package = let
        base = config.boot.kernelPackages.nvidiaPackages.latest;
        cachyos-nvidia-patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/CachyOS/CachyOS-PKGBUILDS/master/nvidia/nvidia-utils/kernel-7.0.patch";
          sha256 = "sha256-PRejd6Tdt81VgYjjVfXfyOQvv12NInw9mxfPT6CMD/E=";
        };

        # Patch the appropriate driver based on config.hardware.nvidia.open
        driverAttr =
          if config.hardware.nvidia.open
          then "open"
          else "bin";
      in
        base
        // {
          ${driverAttr} = base.${driverAttr}.overrideAttrs (oldAttrs: {
            patches = (oldAttrs.patches or []) ++ [cachyos-nvidia-patch];
          });
        };

      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";

        # Offload Mode, primary using integrated GPU
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        # Sync Mode, primary using discrete GPU
        # sync.enable = true;
      };
    };
  };
}
