{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.home.wm.hyprland;
in {
  options.features.home.wm.hyprland = {
    enable = mkEnableOption "Enable Hyprland";
    virtKeyboard = mkOption {
      type = types.bool;
      default = false;
    };
  };

  imports = [
    ./hyprland.nix
    # ./waybar.nix
    ./quickshell.nix
  ];

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        #   alacritty
        killall

        wireplumber
        ulauncher

        zenity
        polkit_gnome
        libva-utils
        gsettings-desktop-schemas
        grim
        slurp
        libsForQt5.qt5.qtwayland
        qt6.qtwayland
        pavucontrol
        pamixer
        waypipe
        wf-recorder
        wl-mirror
        wl-clipboard
        hyprland-protocols
        hyprpicker
        hyprpaper
        hypridle
        xdg-utils
        xdg-desktop-portal-hyprland
      ]
      ++ optionals cfg.virtKeyboard [pkgs.wvkbd];
  };
}
