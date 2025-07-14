{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.wm.dunst;

  dunstReload = pkgs.writeShellScriptBin "dunstReload" ''
    pkill dunst
    dunst &

    notify-send -u critical "Test message: critical test 1"
    notify-send -u normal "Test message: normal test 2"
    notify-send -u low "Test message: low test 3"
    notify-send -u critical "Test message: critical test 4"
    notify-send -u normal "Test message: normal test 5"
    notify-send -u low "Test message: low test 6"
    notify-send -u critical "Test message: critical test 7"
    notify-send -u normal "Test message: normal test 8"
    notify-send -u low "Test message: low test 9"
  '';
in {
  options.features.home.wm.dunst.enable = mkEnableOption "Enable Dunst";

  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          # font = userSettings.fontMono + " 8";
          allow_markup = "yes";
          sort = "yes";
          indicate_hidden = "yes";
          alignment = "left";
          bounce_freq = 0;
          show_age_threshold = 60;
          word_wrap = "yes";
          ignore_newline = "no";
          transparency = 10;
          width = 300;
          height = 200;
          offset = "30x50";
          origin = "top-right";
          monitor = 0;
          follow = "keyboard";
          sticky_history = "yes";
          line_height = 0;
          separator_height = 2;
          padding = 8;
          horizontal_padding = 8;
          separator_color = "frame";
          startup_notification = true;
        };
        frame = {
          width = 0;
          # color = config.colorScheme.palette.base08;
          color = "#000f00";
        };
        urgency_low = {
          background = "#222222";
          foreground = "#888888";
          timeout = 10;
        };

        urgency_normal = {
          background = "#285577";
          foreground = "#ffffff";
          timeout = 10;
        };

        urgency_critical = {
          background = "#900000";
          foreground = "#ffffff";
          timeout = 0;
        };
      };
    };
  };
}
