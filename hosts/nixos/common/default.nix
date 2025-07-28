{
  pkgs,
  lib,
  config,
  inputs,
  outputs,
  ...
}: {
  imports = [
    # ./extraServices
    ./users
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs outputs;
      hostName = config.networking.hostName;
    };
  };
  nixpkgs = {
    # overlays = [
    #   # Add overlays your own flake exports (from overlays and pkgs dir):
    #   # outputs.overlays.additions
    #   # outputs.overlays.modifications
    #   outputs.overlays.stable-packages
    #
    #   # You can also add overlays exported from other flakes:
    #   # neovim-nightly-overlay.overlays.default
    #
    #   # Or define it inline, for example:
    #   # (final: prev: {
    #   #   hi = final.hello.overrideAttrs (oldAttrs: {
    #   #     patches = [ ./change-hello-to-hi.patch ];
    #   #   });
    #   # })
    # ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "bata"
      ]; # Set users that are allowed to use the flake command
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };
    optimise.automatic = true;
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    # nixPath = ["/etc/nix/path"] ++ lib.mapAttrsToList (flakeName: _: "${flakeName}=flake:${flakeName}") flakeInputs;
  };

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

  environment.systemPackages = with pkgs; [
    just
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

  users.mutableUsers = false; # Needed for pw set by sops!
  users.users.bata = {
    isNormalUser = true;
    description = "Bastian Sievers";
    extraGroups = ["networkmanager" "wheel" "docker" "surface-control"];
  };

  services.openssh = {
    enable = true;
    ports = [22];
    openFirewall = true;
    settings = {
      AllowUsers = ["bata"];
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
    allowSFTP = true;
  };
  security.sudo.extraConfig = "bata ALL=(ALL) NOPASSWD: ALL";
}
