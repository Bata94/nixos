{
  inputs,
  pkgs,
  lib,
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
      "software_pw/google" = {};
      "software_pw/github" = {};
    };
  };

  features = {
    hardware = {
      bluetooth.enable = true;
      intel-gpu.enable = true;
      iptsd.enable = true;
      opengl.enable = true;
      printing.enable = true;
      power.enable = true;
      systemd.enable = true;
      time.enable = true;
    };
    system = {
      desktop = {
        wm.hyprland.enable = true;
      };
    };
  };

  boot.loader.systemd-boot.enable = true; # lib.mkForce false;
  # boot.lanzaboote = {
  #   enable = true;
  #   pkiBundle = "/var/lib/sbctl";
  # };
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = with pkgs; [
    sbctl # key gen and mgmt for secureboot
  ];

  # programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = [];

  networking = {
    hostName = "grievous";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
      allowedUDPPorts = [];
    };
  };

  system.stateVersion = "26.05";
}
