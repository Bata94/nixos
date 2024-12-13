{pkgs, ...}: {
  imports = [
    ./disko-configuration.nix
    ./hardware-configuration.nix
  ];

  nix.package = pkgs.nixVersions.stable;
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

  users.users.bata = {
    isNormalUser = true;
    description = "Bastian Sievers";
    extraGroups = ["networkmanager" "wheel" "docker"];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    just
  ];

  environment.shells = with pkgs; [bash zsh];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = [];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
    allowSFTP = true;
  };
  security.sudo.extraConfig = "bata ALL=(ALL) NOPASSWD: ALL";

  networking.hostName = "test";
  networking.networkmanager.enable = true;
  # networking.nat.enable = true;
  # networking.nat.internalInterfaces = ["ve-+"];
  # networking.nat.externalInterface = "enp1s0";
  # networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [  ];

  system.stateVersion = "24.11";
}