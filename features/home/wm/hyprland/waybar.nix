{
  config,
  ...
}:
let
    colors = config.colorScheme.palette;
    defFont = "FiraCode Nerd Font";
    defOpacity = "0.8";
    defFontSize = "13px";
    biggerFontSize = "14px";
    bigIconFontSize = "16px";
in {
  programs.waybar = {
    enable = true;
    settings = {
      topBar = {
        "layer" = "top";
        "height" = 20;
        "margin-left" = 4;
        "margin-right" = 8;
        "margin-top" = 2;
        "margin-bottom" = 2;
        "spacing" = 4;

        # Load Modules
        # Workspaces
        "hyprland/workspaces" = {
          "on-click" = "activate";
          "active-only" = false;
          "all-outputs" = true;
        };
        # Hyprland Window
        "hyprland/window" = {
          "separate-outputs" = true;
        };
        # OS Icon
        "custom/osIcon" = {
          "format" = ""; # 󰣇   
          "on-click" = "sleep 0.1 && alacritty";
          "on-click-right" = "sleep 0.1 && ulauncher-toggle";
          "on-click-middle" = "sleep 0.1 && firefox";
          "tooltip" = false;
        };
        # Cliphist
        "custom/cliphist" = {
          "format" = " ";
          # "on-click" = "sleep 0.1 && ~/dotfiles/scripts/cliphist.sh";
          # "on-click-right" = "sleep 0.1 && ~/dotfiles/scripts/cliphist.sh d";
          # "on-click-middle" = "sleep 0.1 && ~/dotfiles/scripts/cliphist.sh w";
          "tooltip" = false;
        };
        # Power Menu
        "custom/exit" = {
          "format" = " ";
          "on-click" = "wlogout";
          "tooltip" = false;
        };
        # System tray
        "tray" = {
          "icon-size" = 12;
          "spacing" = 6;
        };
        #clock
        "clock" = {
          "format" = "{:%A, %d.%m.%Y - %H:%M}";
          "tooltip-format" = "<tt><small>{calendar}</small></tt>";
          "calendar" = {
            "mode" = "year";
            "mode-mon-col" = 3;
            "weeks-pos" = "right";
            "on-scroll" = 1;
            "on-click-right" = "mode";
            "format" = {
              "months" = "<span color='#ffead3'><b>{}</b></span>";
              "days" = "<span color='#ecc6d9'><b>{}</b></span>";
              "weeks" = "<span color='#99ffdd'><b>W{}</b></span>";
              "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
              "today" = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          "actions" = {
            "on-click-right" = "mode";
            "on-click-forward" = "tz_up";
            "on-click-backward" = "tz_down";
            "on-scroll-up" = "shift_up";
            "on-scroll-down" = "shift_down";
          };
        };
        # CPU
        "cpu" = {
          "format" = " {usage}%";
          "min-length" = 6;
          "on-click" = "alacritty -e htop";
        };
        # Memory
        "memory" = {
          "format" = "󰍛 {}%";
          "min-length" = 6;
          "on-click" = "alacritty -e htop";
        };
        # GPU-Intel
        "custom/gpu-intel" = {
          "exec" = "";
          "format" = "󰍹 {}%";
          "min-length" = 6;
          "on-click" = "alacritty -e nvtop";
          "return-type" = "";
          "interval" = 1;
        };
        # GPU
        "custom/gpu" = {
          "exec" = "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits";
          "format" = "󰍺 {}%";
          "min-length" = 6;
          "on-click" = "alacritty -e nvtop";
          "return-type" = "";
          "interval" = 1;
        };
        # Harddisc space used
        "disk" = {
          "interval" = 60;
          "format" = " {percentage_used}%";
          "min-length" = 6;
          "path" = "/";
          "on-click" = "alacritty -e htop";
        };
        # Network
        "network" = {
          "format" = "";
          "format-wifi" = " {signalStrength}%";
          "format-ethernet" = "󰛳 ";
          "format-disconnected" = ""; #An empty format will hide the module.
          "tooltip-format" = " {ifname} via {gwaddri}";
          "tooltip-format-wifi" = "   {essid} ({signalStrength}%)";
          "tooltip-format-ethernet" = "󰛳 {ifname} ({ipaddr}/{cidr})";
          "tooltip-format-disconnected" = "󰌙";
          "max-length" = 50;
        };
        # Battery
        "battery" = {
          "states" = {
            "good" = 60;
            "warning" = 30;
            "critical" = 15;
          };
          "format-time" = "{H}:{m}";
          "format" = "{icon}  {capacity}%";
          "format-charging" = "{icon}  {capacity}%";
          "format-alt" = "{icon} {time}";
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
          ];
          "format-charging-icons" = [
            "󰢟"
            "󱊤"
            "󱊥"
            "󱊦"
            "󰂅"
          ];
        };
        # Backlight
        "backlight" = {
          "device" = "intel_backlight";
          "format" = "{icon} {percent}%";
          "format-icons" = [
            ""
            ""
          ];
          "scroll-step" = 5;
          "on-click-middle" = "~/dotfiles/scripts/brightnesscontrol default";
        };
        # Pulseaudio
        "pulseaudio" = {
          "format" = "{icon} {volume}%";
          "format-bluetooth" = "{icon} {volume}%";
          "format-bluetooth-muted" = "{icon} 󰝟";
          "format-muted" = "󰝟  {format_source}";
          "format-source" = "{volume}% ";
          "format-source-muted" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = " ";
            "headset" = " ";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = [
              ""
              ""
              ""
            ];
          };
          "on-click" = "pavucontrol";
          "on-click-middle" = "~/dotfiles/scripts/volumecontrol mute";
          "scroll-step" = 5;
        };
        # Bluetooth
        "bluetooth" = {
          "format" = " ";
          "format-connected" = "󰂱 ";
          "format-disabled" = "";
          "format-off" = "";
          "interval" = 30;
          "on-click" = "blueman-manager";
        };
        # Other
        "user" = {
          "format" = "{user}";
          "interval" = 60;
          "icon" = false;
        };

        # Modules Left
        "modules-left" = [
          "custom/osIcon"
          "hyprland/workspaces"
          # "hyprland/window"
        ];

        # Modules Center
        "modules-center" = [
          "clock"
        ];

        # Modules Right
        "modules-right" = [
          "group/hardware"
          "backlight"
          "pulseaudio"
          "battery"
          "network"
          "bluetooth"
          "custom/cliphist"
          "tray"
          "custom/exit"
        ];

        # Group Hardware
        "group/hardware" = {
          "orientation" = "horizontal";
          "modules" = [
            "cpu"
            "memory"
            "custom/gpu-intel"
            "custom/gpu"
            "disk"
          ];
        };
      };
    };
    style = ''
      /* -----------------------------------------------------
       * General
       * ----------------------------------------------------- */

      * {
          font-family: "${defFont}";
          border: none;
          border-radius: 0px;
          padding: 0px;
          margin: 0px;
          font-size: ${defFontSize};
          font-weight: bold;
          font-style: normal;
      }

      window#waybar {
          background-color: #${colors.base00};
          opacity: ${defOpacity};
          border-bottom: 0px solid #${colors.base07};
          background: transparent;
          transition-property: background-color;
          transition-duration: .5s;
      }

      /* -----------------------------------------------------
       * Workspaces
       * ----------------------------------------------------- */

      #workspaces {
          border-radius: 0px;
          border:0px;
          opacity: ${defOpacity};
          color:#${colors.base05};
      }

      #workspaces button {
          font-size: ${biggerFontSize};
          padding: 0px 2px;
          margin: 4px 2px;
          border-radius: 0px;
          border: 0px;
          color: #${colors.base06};
          background: #${colors.base0E};
          transition: all 0.3s ease-in-out;
          opacity:0.4;
      }

      #workspaces button.active {
          margin: 2px 2px;
          color: #${colors.base06};
          background: #${colors.base0E};
          border-radius: 0px;
          min-width: 24px;
          transition: all 0.3s ease-in-out;
          opacity:1.0;
      }

      #workspaces button:hover {
          margin: 4px 2px;
          color: #${colors.base06};
          background: #${colors.base0E};
          border-radius: 0px;
          opacity:0.7;
      }

      /* -----------------------------------------------------
       * Tooltips
       * ----------------------------------------------------- */

      tooltip {
          border-radius: 0px;
          background-color: #${colors.base00};
          opacity: ${defOpacity};
          padding:20px;
          margin:0px;
      }

      tooltip label {
          color: #${colors.base08};
      }

      /* -----------------------------------------------------
       * Window
       * ----------------------------------------------------- */

      #window {
          background: #${colors.base05};
          margin: 4px 2px;
          padding: 2px 4px;
          border-radius: 0px;
          color: #${colors.base00};
          opacity: ${defOpacity};
      }

      window#waybar.empty #window {
          background-color:transparent;
      }

      /* -----------------------------------------------------
       * Modules
       * ----------------------------------------------------- */

      .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
      }

      .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
      }

      /* -----------------------------------------------------
       * Custom Exit
       * ----------------------------------------------------- */

      #custom-exit {
          font-size:14px;
          color:#${colors.base05};
          opacity: ${defOpacity};
      }

      /* -----------------------------------------------------
       * Custom Updates
       * ----------------------------------------------------- */

      #custom-updates {
          margin: 4px 2px;
          padding: 2px 4px;
          background-color: #${colors.base05};
          color: #${colors.base00};
          border-radius: 0px;
          opacity: ${defOpacity};
      }

      #custom-updates.green {
          background-color: #${colors.base05};
      }

      #custom-updates.yellow {
          background-color: #${colors.base0A};
          color: #${colors.base07};
      }

      #custom-updates.red {
          background-color: #${colors.base08};
          color: #${colors.base07};
      }

      /* -----------------------------------------------------
       * Hardware Group
       * ----------------------------------------------------- */

      #disk,#memory,#cpu,#custom-gpu {
          margin:0px;
          padding:0px;
          opacity: ${defOpacity};
      }

      #group-hardware{
          opacity: ${defOpacity};
          background-color: #${colors.base08};
          color: #${colors.base05};
      }

      /* -----------------------------------------------------
       * Clock
       * ----------------------------------------------------- */

      #clock {
          margin: 0px 30px;
          opacity: ${defOpacity};
      }

      /* -----------------------------------------------------
       * Pulseaudio
       * ----------------------------------------------------- */

      #pulseaudio {
          opacity: ${defOpacity};
      }

      #pulseaudio.muted {
          opacity: ${defOpacity};
      }

      /* -----------------------------------------------------
       * Backlight
       * ----------------------------------------------------- */

       #backlight {
          opacity: ${defOpacity};
      }

      /* -----------------------------------------------------
       * Network
       * ----------------------------------------------------- */

      #network {
          opacity: ${defOpacity};
      }

      /* -----------------------------------------------------
       * Bluetooth
       * ----------------------------------------------------- */

      #bluetooth.on, #bluetooth.connected {
          opacity: ${defOpacity};
      }

      #bluetooth.off {
          background-color: transparent;
      }

      /* -----------------------------------------------------
       * Battery
       * ----------------------------------------------------- */

      #battery {
          opacity: ${defOpacity};
      }

      #battery.charging, #battery.plugged {
          color: #${colors.base07};
      }

      @keyframes blink {
          to {
              color: #${colors.base00};
          }
      }

      #battery.critical:not(.charging) {
          color: #${colors.base07};
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      /* -----------------------------------------------------
       * Tray
       * ----------------------------------------------------- */

      #tray {
          background-color: transparent;
          margin: 0px 8px;
          opacity: ${defOpacity};
      }

      #tray > .passive {
          -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: #${colors.base08};
      }

      /* -----------------------------------------------------
       * OS Icon
       * ----------------------------------------------------- */

      #custom-osIcon {
          font-size: ${bigIconFontSize};
          font-weight: bold;
          margin: 0px 8px;
          opacity: ${defOpacity};
      }

      #custom-cliphist {
          opacity: ${defOpacity};
      }

      /* -----------------------------------------------------
       * Other
       * ----------------------------------------------------- */

      label:focus {
          background-color: #${colors.base00};
      }
    '';
  };
}
