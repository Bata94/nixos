{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.wm.dbus;
in {
  options.features.desktop.wm.dbus.enable = mkEnableOption "Enable DBUS services";

  config = mkIf cfg.enable {
    services.dbus = {
      enable = true;
      packages = [pkgs.dconf];
    };

    programs.dconf = {
      enable = true;
    };
  };
}
