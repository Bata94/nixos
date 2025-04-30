{
  # config,
  # inputs,
  pkgs,
  ...
}:
{
  nix.settings.trusted-users = [ "bata" ];

  # age.secrets.hashedUserPassword = {
  #   file = "${inputs.secrets}/hashedUserPassword.age";
  # };

  users = {
    users = {
      bata = {
        shell = pkgs.zsh;
        uid = 1000;
        isNormalUser = true;
        description = "Bastian Sievers";
        # hashedPasswordFile = config.age.secrets.hashedUserPassword.path;
        extraGroups = [
          "wheel"
          "users"
          "docker"
          "podman"
          "input"
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
        group = "bata";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN+WfV3PWmp9PHJKcFWlECuhZ1AScCk691D7Z6En6Fg0 bastian.sievers@gmail.com"
        ];
      };
    };
    groups = {
      bata = {
        gid = 1000;
      };
    };
  };

  programs.zsh.enable = true;

  home.programs.gh = {
    enable = true;
  };
}
