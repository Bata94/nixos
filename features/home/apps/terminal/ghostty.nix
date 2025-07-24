{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.apps.terminal.ghostty;
in {
  options.features.home.apps.terminal.ghostty.enable = mkEnableOption "Enable Ghostty";

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      clearDefaultKeybinds = false;
      settings = {
        theme = "rose-pine";
        window-theme = "ghostty";

        mouse-scroll-multiplier = 0.5;

        background = "000000";
        background-opacity = 0.8;
        background-blur-radius = 20;

        gtk-titlebar = false;
        gtk-tabs-location = "hidden";
        gtk-single-instance = true;

        font-size = 9.0;
        font-family = "FiraMono Nerd Font";

        keybind = [
          "alt+1=unbind"
          "alt+2=unbind"
          "alt+3=unbind"
          "alt+4=unbind"
          "alt+5=unbind"
          "alt+6=unbind"
          "alt+7=unbind"
          "alt+8=unbind"
          "alt+9=unbind"
          "alt+0=unbind"
          "alt+t=unbind"
        ];
      };
    };
  };
}
