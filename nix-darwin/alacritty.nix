{...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      # colors = with config.colorScheme.palette; {
      #   bright = {
      #     black = "0x${base03}";
      #     blue = "0x${base0D}";
      #     cyan = "0x${base0C}";
      #     green = "0x${base0B}";
      #     magenta = "0x${base0E}";
      #     red = "0x${base08}";
      #     white = "0x${base07}";
      #     yellow = "0x${base0A}";
      #   };
      #   cursor = {
      #     cursor = "0x${base04}";
      #     text = "0x${base05}";
      #   };
      #   normal = {
      #     black = "0x${base03}";
      #     blue = "0x${base0D}";
      #     cyan = "0x${base0C}";
      #     green = "0x${base0B}";
      #     magenta = "0x${base0E}";
      #     red = "0x${base08}";
      #     white = "0x${base07}";
      #     yellow = "0x${base0A}";
      #   };
      #   primary = {
      #     background = "0x${base00}";
      #     foreground = "0x${base06}";
      #   };
      #   draw_bold_text_with_bright_colors = true;
      # };

      font = {
        bold = {
          family = "FiraCode Nerd Font Mono";
          style = "Bold";
        };
        bold_italic = {
          family = "FiraCode Nerd Font Mono";
          style = "Bold Italic";
        };
        italic = {
          family = "FiraCode Nerd Font Mono";
          style = "Italic";
        };
        normal = {
          family = "FiraCode Nerd Font Mono";
          style = "Regular";
        };
        size = 9;
      };

      scrolling.history = 50000;
      # decorations = "None";

      cursor.style = {
        shape = "Beam";
        blinking = "On";
      };

      window = {
        padding = {
          x = 1;
          y = 0;
        };
        opacity = 0.8;
      };
    };
  };
}
