{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.hardware.kernel;
in {
  options.features.hardware.kernel.enable = mkEnableOption "Enable special kernel settings";

  config = mkIf cfg.enable {
    # boot.kernelPackages = pkgs.linuxPackages_zen;
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.consoleLogLevel = 0;
    # boot.extraModulePackages = with config.boot.kernelPackages; [];
    # boot.blacklistedKernelModules = [
    #   "nouveau"
    # ];
    boot.extraModprobeConfig = ''
      blacklist nouveau
      options nvidia-drm modeset=1
    '';
  };
}
