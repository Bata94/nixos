{ config, lib, pkgs, ... }:
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
    home.packages = with pkgs; [
      #   alacritty
      killall

      wireplumber
      ulauncher

      ## Deps via quickshell (caelestia-shell)
      ddcutil
      # brightnessctl
      app2unit
      cava
      networkmanager
      lm_sensors
      # grim
      swappy
      # wl-clipboard
      libqalculate
      inotify-tools
      bluez
      coreutils
      findutils
      file
      ## Caelestia-cli
      # swappy
      libnotify
      # slurp
      # wl-clipboard
      cliphist
      # app2unit
      dart-sass
      # grim
      fuzzel
      wl-screenrec
      dconf
      # killall
      ## Div

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
    ] ++ [
      python3.pkgs.hatch-vcs
      python3.pkgs.hatchling
      python3.pkgs.materialyoucolor
      python3.pkgs.pillow
    ] ++ optionals cfg.virtKeyboard [ pkgs.wvkbd ];
  };
}
