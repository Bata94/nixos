{
  inputs,
  pkgs,
  lib,
  ...
}: let
  xpsStartupScript = pkgs.writeShellScriptBin "xpsStartupScript" ''
    #!/usr/bin/env bash

    echo "XPS Startup Script, to enable BIOS probing to increase Performance and Powerstates."
    rmmod intel_rapl_msr
    rmmod processor_thermal_device_pci_legacy
    rmmod processor_thermal_device
    rmmod processor_thermal_rapl
    rmmod intel_rapl_common
    rmmod intel_powerclamp
    modprobe intel_powerclamp
    modprobe intel_rapl_common
    modprobe processor_thermal_rapl
    modprobe processor_thermal_device
    modprobe intel_rapl_msr
    echo "Probing done. Now setting Thermal Mode..."

    smbios-thermal-ctl --set-thermal-mode balanced
    echo "Thermal Mode set to Balanced."
  '';
in {
  imports = [
    # ./disko-configuration.nix
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

  # TODO: Add disabled Nvidia Spec again
  # XPS BIOS PowerSettings
  environment.systemPackages = with pkgs; [
    libsmbios
  ];
  systemd.services.xpsStartupScript = {
    enable = true;
    description = "XPS Startup Script, to enable BIOS probing to increase Performance and Powerstates.";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      User = "root";
      Group = "root";
      ExecStart = "${pkgs.zsh}/bin/zsh ${xpsStartupScript}/bin/xpsStartupScript";
    };
  };

  features = {
    hardware = {
      bluetooth.enable = true;
      # display.enable = true;
      # intel-gpu.enable = true;
      # iptsd.enable = true;
      kernel.enable = true;
      nvidia-gpu.enable = true;
      opengl.enable = true;
      power.enable = true;
      printing.enable = true;
      systemd.enable = true;
      time.enable = true;
    };
    system = {
      desktop = {
        wm.hyprland.enable = true;
        gaming.enable = true;
      };
      services = {
        docker.enable = true;
        ollama.enable = false;
        virtualization.enable = true;
      };
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = [];

  networking = {
    hostName = "anakin";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
      allowedUDPPorts = [];
    };
  };

  system.stateVersion = "25.11";
}
