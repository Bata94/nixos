{
  config,
  pkgs,
  inputs,
  ...
}: {
  users.users.bata = {
    initialHashedPassword = "$y$j9T$hWU0.PI9I8Tj1.mubjMeu0$cIfImoHoERBv6F.HGcpS7Xj5kQdhf0i/IPDIvT811l0";
    isNormalUser = true;
    description = "Bastian Sievers";
    uid = 1000;
    extraGroups = [
      "wheel"
      "docker"
      "adb"
      "networkmanager"
      "flatpak"
      "audio"
      "video"
      "plugdev"
      "input"
      "kvm"
      "libvirt"
      "libvirt-qemu"
      "qemu-libvirtd"
      "libvirt-guests"
      "libvirtd"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN+WfV3PWmp9PHJKcFWlECuhZ1AScCk691D7Z6En6Fg0 bastian.sievers@gmail.com"
    ];
    packages = [inputs.home-manager.packages.${pkgs.system}.default];
  };
  home-manager.users.bata = import ../../../users/bata/${config.networking.hostName}.nix;
}
