{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.system.desktop.wm.thunar;
in {
  options.features.system.desktop.wm.thunar.enable = mkEnableOption "Enable Thunar";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      thunar
      xfconf

      feh
      mpv
      vlc
    ];

    programs.xfconf.enable = true;

    programs.thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    services.gvfs.enable = true; # Mount, trash, and other functionalities
    services.tumbler.enable = true; # Thumbnail support for images
  };
}
