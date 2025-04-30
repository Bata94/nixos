{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.hardware.opengl;
in {
  options.hardware.opengl.enable = mkEnableOption "Enable opengl";

  config = mkIf cfg.enable {
    # environment.systemPackages = with pkgs; [
    #   vulkan-tools
    #   vulkan-validation-layers
    #   vaapiVdpau
    #   libvdpau-va-gl
    # ];

    services.xserver.videoDrivers = ["nvidia"];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      # extraPackages = with pkgs; [
      #   # vaapiVdpau
      #   # libvdpau-va-gl
      #   vulkan-tools
      #   vulkan-validation-layers
      #
      #   intel-media-driver # LIBVA_DRIVER_NAME=iHD
      #   intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      #   # libvdpau-va-gl
      #
      #   # Test
      #   nvidia-vaapi-driver
      #   vpl-gpu-rt          # for newer GPUs on NixOS >24.05 or unstable
      # ];
    };
  };
}
