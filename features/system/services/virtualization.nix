{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.system.services.tailscale;
in {
  options.features.system.services.virtualization.enable = mkEnableOption "Enable virtualization";
  options.features.system.services.virtualization.guiApps = mkEnableOption "Enable virtualization GUI Apps";

  config = mkIf cfg.enable {
    programs.dconf.enable = true;

    environment.systemPackages = with pkgs;
      [
        spice
        spice-gtk
        spice-protocol
        win-virtio
        win-spice
      ]
      ++ mkIf cfg.guiApps [
        virt-manager
        virt-viewer
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
