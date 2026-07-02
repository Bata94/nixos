{
  config,
  lib,
  pkgs,
  inputs,
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
    tablet = mkOption {
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
    # ./hyprlauncher.nix

    # ./quickshell.nix
    inputs.noctalia.homeModules.default
  ];

  config = mkIf cfg.enable {
    home.file.".config/xremap/config.yml".text = ''
      modmap:
        - name: global
          remap:
            CapsLock: Esc
            # CTRL-L: CapsLock
    '';
    home.packages = with pkgs;
      [
        #   alacritty
        killall

        wireplumber
        # ulauncher

        hyprpolkitagent
        hyprpwcenter

        xremap
        zenity
        libva-utils
        gsettings-desktop-schemas
        grim
        slurp
        qt5.qtwayland
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
