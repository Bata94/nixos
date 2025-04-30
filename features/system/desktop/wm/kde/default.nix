{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.wm.kde;
in {
  options.features.desktop.wm.kde.enable = mkEnableOption "Enable KDE Desktop Environment";

  config = mkIf cfg.enable {
    features.desktop.wm = {
      defaultFonts.enable = true;
      dbus.enable = true;
      audio.enable = true;
      thunar.enable = true;
    };

    services.xserver = {
      enable = true;
      xkb = {
        layout = "de";
        variant = "";
      };
    };
    services.libinput.enable = true;

    console.keyMap = "de";
    services.desktopManager.plasma6.enable = true;
    services.displayManager = {
      defaultSession = "plasma";
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
  };
}
