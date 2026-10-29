{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./disko-configuration.nix
    ./hardware-configuration.nix

    ../../../features/hardware
    ../../../features/system

    inputs.sops-nix.nixosModules.sops
  ];
  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    validateSopsFiles = false;

    age = {
      # automatically import host SSH keys as age keys and generate if needed
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    secrets = {
      bata_pw = {
        neededForUsers = true;
      };
    };
  };

  # nix.package = pkgs.nixVersions.stable;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = [];

  # make the tailscale command usable to users
  # environment.systemPackages = [pkgs.tailscale];
  # enable the tailscale service
  services.tailscale.enable = true;

  features = {
    hardware = {
      time.enable = true;
      systemd.enable = true;
    };
    system = {
      services = {
        docker.enable = true;
        sshd.enable = true;
      };
    };
  };

  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "lz4";
    memoryPercent = 50;
  };

  networking = {
    hostName = "naboo";
    firewall = {
      enable = true;
      allowedTCPPorts = [22 11000];
      allowedUDPPorts = [11000];
    };
  };

  system.stateVersion = "26.05";
}
