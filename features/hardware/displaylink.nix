{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.hardware.displaylink;
in {
  options.hardware.displaylink.enable = mkEnableOption "Enable displaylink";

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = ["displaylink" "modesetting"];
    services.xserver.displayManager.sessionCommands = ''
      ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
    '';
  };
}
