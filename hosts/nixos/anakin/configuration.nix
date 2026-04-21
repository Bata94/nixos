{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  xpsStartupScript = let
    platformProfile =
      if config.features.hardware.nvidia-gpu.enable
      then "balanced"
      else "quiet";
  in
    pkgs.writeShellScriptBin "xpsStartupScript" ''
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

      echo "${platformProfile}" | tee /sys/firmware/acpi/platform_profile
      echo "Thermal Mode set to ${platformProfile}."
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

  services.fwupd.enable = true;

  environment.systemPackages = with pkgs; [
    libsmbios

    # temp virt pkgs
    spice
    spice-gtk
    spice-protocol
    virtio-win
    win-spice
    # virt-manager
    virt-viewer
    adwaita-icon-theme
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

  # Keychron F-Key setup
  boot.extraModprobeConfig = ''
    options hid_apple fnmode=0
  '';

  features = {
    hardware = {
      bluetooth.enable = true;
      # display.enable = true;
      intel-gpu.enable = true;
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
        virtualization = {
          enable = false;
          guiApps = false;
        };
      };
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [];

  # This is the one that correctly adds the udev rules!
  # programs.adb.enable = true; # deprecated

  # Not sure if this is necessary if the above is set?
  # services.udev.packages = [
  #   pkgs.android-udev-rules
  # ];

  programs.dconf.enable = true;
  programs.virt-manager.enable = true;
  # environment.systemPackages = with pkgs; [
  #   spice
  #   spice-gtk
  #   spice-protocol
  #   virtio-win
  #   win-spice
  #   virt-manager
  #   virt-viewer
  #   adwaita-icon-theme
  # ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        # ovmf.enable = true;
        # ovmf.packages = [pkgs.OVMFFull.fd];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;

  users.groups.libvirtd.members = ["bata"];

  networking = {
    hostName = "anakin";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
      allowedUDPPorts = [];
    };
    # wg-quick.interfaces = {
    #   # TODO: Move to age file!!
    #   wg0 = {
    #     address = [
    #       "10.42.0.10/32"
    #     ];
    #     dns = ["10.42.0.0"];
    #     privateKey = "UCs7B506W8PRA5tCcuL+1+8cNiBPeWvuRk1eA8eUuGE=";
    #     peers = [
    #       {
    #         publicKey = "BLTPU3Q3y31pnWy10k2r1RiHY/dYSASckUDuyixJxmk=";
    #         presharedKey = "BtRpgfHFxSQfC0sgFZD3PxuaYU0BcO078+3yXb71r60=";
    #         allowedIPs = [
    #           "10.42.0.0/24"
    #           "10.69.0.0/24"
    #         ];
    #         endpoint = "138.199.198.213:51820";
    #         persistentKeepalive = 25;
    #       }
    #     ];
    #   };
    # };
  };

  system.stateVersion = "26.05";
}
