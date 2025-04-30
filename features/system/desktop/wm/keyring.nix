{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.wm.keyring;
in {
  options.features.desktop.wm.keyring.enable = mkEnableOption "Enable Keyring";

  config = mkIf cfg.enable {
    services.gnome = {
      gnome-keyring.enable = true;
    };
  };
}
