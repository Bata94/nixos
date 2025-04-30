{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.wm.thunar;
in {
  options.features.desktop.wm.thunar.enable = mkEnableOption "Enable Thunar";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xfce.thunar
      xfce.xfconf

      feh
      mpv
      vlc
    ];

    programs.xfconf.enable = true;

    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    services.gvfs.enable = true; # Mount, trash, and other functionalities
    services.tumbler.enable = true; # Thumbnail support for images
  };
}
