{pkgs, ...}: let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  session = "${pkgs.hyprland}/bin/Hyprland";
  username = "bata";
in {
  imports = [
    # ./disko-configuration.nix
    ./hardware-configuration.nix

    ../../../features/hardware
  ];

  features = {
    hardware = {
      bluetooth.enable = true;
    };
  };

  services = {
    xserver.enable = true;
    greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "${session}";
          user = "${username}";
        };
        default_session = {
          command = "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time -cmd ${session}";
          user = "${username}";
        };
      };
    };
  iptsd = {
    enable = true;
    config = {
      Touchscreen = {
        DisableOnPalm = true;
        DisableOnStylus = true;
      };
    };
  };

  };

  fonts.packages = with pkgs; [
    corefonts
    cm_unicode

    font-awesome
    powerline-fonts
    powerline-symbols

    ubuntu_font_family
    source-code-pro
    jetbrains-mono
    twemoji-color-font
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    kanji-stroke-order-font
    ipafont

    nerd-fonts.symbols-only
    nerd-fonts.noto
    nerd-fonts.fira-code
    nerd-fonts.inconsolata
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.iosevka
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };
  console.keyMap = "de";
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  users.users.bata = {
    isNormalUser = true;
    description = "Bastian Sievers";
    extraGroups = ["networkmanager" "wheel" "docker" "surface-control"];
  };

  programs = {
    hyprland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    htop
    btop
    powertop
  ];

  environment.shells = with pkgs; [bash zsh];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = [];

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    openFirewall = true;
    settings = {
      AllowUsers = [ "bata" ];
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
    allowSFTP = true;
  };
  security.sudo.extraConfig = "bata ALL=(ALL) NOPASSWD: ALL";

  networking = {
    hostName = "grievous";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [  ];
    };
  };

  system.stateVersion = "25.05";
}
