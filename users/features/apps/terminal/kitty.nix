{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.apps.terminal.kitty;
in {
  options.features.apps.terminal.kitty.enable = mkEnableOption "Enable kitty";

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      settings = {
        background_opacity = lib.mkForce "0.6";

        font_size = "9.0";
        font_family = "FiraCode Nerd Font Light";
        bold_font = "FiraCode Nerd Font Med";
        italic_font = "$FiraCode Nerd Font Light Italic";
        bold_italic_font = "FiraCode Nerd Font Med Italic";

        # First Color dull, second bright
        # Black
        color0 = "#${config.colorScheme.palette.base03}";
        color8 = "#${config.colorScheme.palette.base03}";

        # Red
        color1 = "#${config.colorScheme.palette.base08}";
        color9 = "#${config.colorScheme.palette.base08}";

        # Green
        color2 = "#${config.colorScheme.palette.base0B}";
        color10 = "#${config.colorScheme.palette.base0B}";

        # Yellow
        color3 = "#${config.colorScheme.palette.base0A}";
        color11 = "#${config.colorScheme.palette.base0A}";

        # Blue
        color4 = "#${config.colorScheme.palette.base0D}";
        color12 = "#${config.colorScheme.palette.base0D}";

        # Magenta
        color5 = "#${config.colorScheme.palette.base0E}";
        color13 = "#${config.colorScheme.palette.base0E}";

        # Cyan
        color6 = "#${config.colorScheme.palette.base0C}";
        color14 = "#${config.colorScheme.palette.base0C}";

        # White
        color7 = "#${config.colorScheme.palette.base07}";
        color15 = "#${config.colorScheme.palette.base07}";

        mark1_background = "#${config.colorScheme.palette.base00}";
        mark1_foreground = "#${config.colorScheme.palette.base06}";

        mark2_background = "#${config.colorScheme.palette.base00}";
        mark2_foreground = "#${config.colorScheme.palette.base06}";

        mark3_background = "#${config.colorScheme.palette.base00}";
        mark3_foreground = "#${config.colorScheme.palette.base06}";
      };
    };
  };
}
