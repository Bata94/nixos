{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.services.tailscale;
in {
  options.features.desktop.services.virtualization.enable = mkEnableOption "Enable virtualization";

  config = mkIf cfg.enable {
    programs.dconf.enable = true;

    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      win-virtio
      win-spice
      adwaita-icon-theme
    ];

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
          ovmf.enable = true;
          ovmf.packages = [pkgs.OVMFFull.fd];
        };
      };
      spiceUSBRedirection.enable = true;
    };
    services.spice-vdagentd.enable = true;
  };
}