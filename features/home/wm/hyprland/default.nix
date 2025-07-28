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
    nvidia_envs = mkOption {
      type = types.bool;
      default = false;
    };
    exec-once-services = mkOption {
      type = types.listOf types.str;
      default = [];
    };
    exec-once-apps = mkOption {
      type = types.listOf types.str;
      default = [];
    };
    monitors = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };

  imports = [
    ./hyprland.nix
    ./hyprpaper.nix

    ./quickshell.nix
  ];

  config = mkIf cfg.enable {
    home.file."xremap/config.yml".text = ''
      remap:
      - from:
          key: CapsLock
        to:
          key: Escape
      - from:
          key: l
          modifiers: [ Control, Shift ]
        to:
          toggle_key: CapsLock
    '';
    home.packages = with pkgs;
      [
        #   alacritty
        killall

        wireplumber
        ulauncher

        xremap
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
