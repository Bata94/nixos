{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.wm.hyprland;
in {
  options.features.desktop.wm.hyprland.enable = mkEnableOption "Enable Hyprland";

  config = mkIf cfg.enable {
    features.desktop.wm = {
      defaultFonts.enable = true;
      dbus.enable = true;
      audio.enable = true;
      keyring.enable = true;
      thunar.enable = true;
    };

    # Configure xwayland
    console.keyMap = "de";
    services.xserver = {
      enable = true;
      xkb = {
        layout = "de";
        variant = "";
        options = "";
      };
      excludePackages = [pkgs.xterm];
    };

    # Configure tuigreet
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --greeting 'Welcome to NixOS' --time --time-format '%I:%M %p | %a • %h | %F' --cmd Hyprland";
          user = "bata";
        };
        shell_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --greeting 'Welcome to NixOS' --time --time-format '%I:%M %p | %a • %h | %F' --cmd zsh";
          user = "bata";
        };
      };
    };
    # environment.systemPackages = with pkgs; [greetd.tuigreet];

    # Configure Hyprland
    environment.systemPackages = with pkgs; [
      killall

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
      # wlogout
      waypipe
      wf-recorder
      wl-mirror
      wl-clipboard
      # waybar
      hyprland-protocols
      hyprpicker
      hyprpaper
      hypridle
      # hyprlock

      libsForQt5.xwaylandvideobridge
    ];

    # Security
    security = {
      # pam.services.swaylock = {
      #   text = ''
      #     auth include login
      #   '';
      # };
      #    pam.services.gtklock = {};
      pam.services.login.enableGnomeKeyring = true;
    };

    services.gnome.gnome-keyring.enable = true;

    programs = {
      hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        xwayland = {
          enable = true;
        };
        portalPackage = pkgs.xdg-desktop-portal-hyprland;
      };
    };

    xdg = {
      portal = {
        enable = true;
        xdgOpenUsePortal = true;
        config = {
          common.default = ["gtk"];
          hyprland.default = ["gtk" "hyprland"];
        };
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-wlr
          # pkgs.xdg-desktop-portal-hyprland
        ];
      };
    };
  };
}
