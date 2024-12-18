{config, lib,...}:
with lib; let
  cfg = config.features.desktop.wm.kde;
in {
  options.features.desktop.wm.kde.enable = mkEnableOption "Enable KDE Desktop Environment";

  config = mkIf cfg.enable {
    services.xserver.enable = true;

    qt = {
      enable = true;
      platformTheme = "qtct";
      style.name = "kvantum";
    };

    xdg.configFile = {
      "Kvantum/ArcDark".source = "${pkgs.arc-kde-theme}/share/Kvantum/ArcDark";
      "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=ArcDark";
    };

    programs.dconf.enable = true;

    services.desktopManager.plasma6.enable = true;
    services.displayManager = {
      sddm.enable = true;
      defaultSession = "plasma";
      sddm.wayland.enable = true;
    };
  };
}
