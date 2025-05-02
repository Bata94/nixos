{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.apps.terminal.ghostty;
in {
  options.features.apps.terminal.alacritty.enable = mkEnableOption "Enable Ghostty";

  config = mkIf cfg.enable {
    home.file.".config/ghostty/config".text = ''
      theme = rose-pine
      window-theme = ghostty

      mouse-scroll-multiplier = 0.5

      background = 000000
      background-opacity = 0.6
      background-blur-radius = 20

      gtk-titlebar = false
      gtk-tabs-location = hidden
      gtk-single-instance = true

      font-size = 9.0
      font-family = FiraMono Nerd Font
    '';
  };
}
