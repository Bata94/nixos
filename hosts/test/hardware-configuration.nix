# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # fileSystems."/" =
  #   { device = "/dev/disk/by-uuid/c1ab6721-7db9-44b2-841c-55e728ab7bbf";
  #     fsType = "ext4";
  #   };
  #
  # fileSystems."/boot" =
  #   { device = "/dev/disk/by-uuid/3782-C70A";
  #     fsType = "vfat";
  #   };
  #
  # swapDevices =
  #   [ { device = "/dev/disk/by-uuid/768429e2-ec61-45f1-879e-78eb335bc91c"; }
  #   ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
