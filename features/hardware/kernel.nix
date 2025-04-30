{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.hardware.kernel;
in {
  options.hardware.kernel.enable = mkEnableOption "Enable special kernel settings";

  config = mkIf cfg.enable {
    # boot.kernelPackages = pkgs.linuxPackages_zen;
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
