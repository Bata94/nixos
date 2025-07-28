{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.features.system.desktop.wm.keyring;
in
{
  options.features.system.desktop.wm.keyring.enable = mkEnableOption "Enable Keyring";

  config = mkIf cfg.enable {
    services.gnome = {
      gnome-keyring.enable = true;
    };
  };
}
