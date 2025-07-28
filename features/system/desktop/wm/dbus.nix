{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.features.system.desktop.wm.dbus;
in
{
  options.features.system.desktop.wm.dbus.enable = mkEnableOption "Enable DBUS services";

  config = mkIf cfg.enable {
    services.dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    programs.dconf = {
      enable = true;
    };
  };
}
