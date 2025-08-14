{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.apps.terminal.ghostty;
in {
  options.features.home.apps.terminal.ghostty.enable = mkEnableOption "Enable Ghostty";
  options.features.home.apps.terminal.ghostty.installPackage = mkOption {
    type = types.bool;
    default = true;
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = !pkgs.stdenv.isDarwin;
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

    # TODO: Error on Linux, because of null input into File
    #   home.file."Library/Application\ Support/com.mitchellh.ghostty/config".text =
    #     mkIf pkgs.stdenv.isDarwin ''
    #       theme = "rose-pine"
    #       window-theme = "ghostty"
    #
    #       mouse-scroll-multiplier = 0.5
    #
    #       background = "000000"
    #       background-opacity = 0.8
    #       background-blur-radius = 20
    #
    #       gtk-titlebar = false
    #       gtk-tabs-location = "hidden"
    #       gtk-single-instance = true
    #
    #       macos-option-as-alt = true
    #
    #       font-size = 9.0
    #       font-family = "FiraMono Nerd Font"
    #
    #       keybind = "alt+1=unbind"
    #       keybind = "alt+2=unbind"
    #       keybind = "alt+3=unbind"
    #       keybind = "alt+4=unbind"
    #       keybind = "alt+5=unbind"
    #       keybind = "alt+6=unbind"
    #       keybind = "alt+7=unbind"
    #       keybind = "alt+8=unbind"
    #       keybind = "alt+9=unbind"
    #       keybind = "alt+0=unbind"
    #       keybind = "alt+t=unbind"
    #     '';
  };
}
