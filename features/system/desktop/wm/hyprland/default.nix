{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.system.desktop.wm.hyprland;

  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
  session = "${pkgs.hyprland}/bin/Hyprland";
  # TODO: Make setable
  username = "bata";
in {
  options.features.system.desktop.wm.hyprland.enable = mkEnableOption "Enable Hyprland";

  config = mkIf cfg.enable {
    features.system.desktop.wm = {
      defaultFonts.enable = true;
      dbus.enable = true;
      audio.enable = true;
      keyring.enable = false;
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
      excludePackages = with pkgs; [
        lightdm
        xterm
      ];
    };

    # Configure tuigreet
    # services.greetd = {
    #   enable = true;
    #   settings = {
    #     ## Surface Settings
    #     initial_session = {
    #       command = "${session}";
    #       user = "${username}";
    #     };
    #     default_session = {
    #       command = "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time -cmd ${session}";
    #       user = "${username}";
    #     };
    #     ## XPS settings
    #     # default_session = {
    #     #   command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --greeting 'Welcome to NixOS' --time --time-format '%I:%M %p | %a • %h | %F' --cmd Hyprland";
    #     #   user = "bata";
    #     # };
    #     # shell_session = {
    #     #   command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --greeting 'Welcome to NixOS' --time --time-format '%I:%M %p | %a • %h | %F' --cmd zsh";
    #     #   user = "bata";
    #     # };
    #   };
    # };
    # environment.systemPackages = with pkgs; [greetd.tuigreet];

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    environment.systemPackages = with pkgs; [
      killall

      hyprpolkitagent

      zenity
      libva-utils
      gsettings-desktop-schemas
      grim
      slurp
      hyprpicker
      grimblast
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

      # kdePackages.xwaylandvideobridge
    ];

    # Security
    # security = {
    # pam.services.swaylock = {
    #   text = ''
    #     auth include login
    #   '';
    # };
    #    pam.services.gtklock = {};
    #   pam.services.login.enableGnomeKeyring = true;
    # };

    # services.gnome.gnome-keyring.enable = true;
  };
}
