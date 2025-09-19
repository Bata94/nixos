{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  customDispatch = pkgs.writeShellScriptBin "customDispatch" ''
    activemonitor=$(hyprctl monitors -j | jq '.[] | select(.focused == true).id')
    passivemonitor=$(hyprctl monitors -j | jq '.[] | select(.focused == false).id')
    activews=$(hyprctl monitors -j | jq '.[] | select(.focused == true).activeWorkspace.id')
    passivews=$(hyprctl monitors -j | jq '.[] | select(.focused == false).activeWorkspace.id')

    # Comment out all lines below except the last to switch back to the default Hyprland dispatch method
    [[ $1 -eq $passivews ]] && [[ $passivemonitor != "$activemonitor" ]] && (hyprctl dispatch swapactiveworkspaces "$activemonitor $passivemonitor")
    hyprctl dispatch moveworkspacetomonitor "$1 $activemonitor"
    hyprctl dispatch focusmonitor "$activemonitor"
    hyprctl dispatch workspace "$1"
  '';
  cfg = config.features.home.wm.hyprland;
in {
  config = mkIf cfg.enable {
    programs.hyprlock.enable = true;
    programs.wlogout = {
      enable = true;
      layout = [
        {
          "label" = "lock";
          "action" = "sleep 1; hyprlock";
          "text" = "Lock";
          "keybind" = "l";
        }
        {
          "label" = "hibernate";
          "action" = "sleep 1; systemctl hibernate";
          "text" = "Hibernate";
          "keybind" = "h";
        }
        {
          "label" = "logout";
          "action" = "sleep 1; loginctl terminate-user $USER";
          "text" = "Logout";
          "keybind" = "e";
        }
        {
          "label" = "shutdown";
          "action" = "sleep 1; systemctl poweroff";
          "text" = "Shutdown";
          "keybind" = "s";
        }
        {
          "label" = "suspend";
          "action" = "sleep 1; systemctl suspend";
          "text" = "Suspend";
          "keybind" = "u";
        }
        {
          "label" = "reboot";
          "action" = "sleep 1; systemctl reboot";
          "text" = "Reboot";
          "keybind" = "r";
        }
      ];
      # style = ''
      #
      # '';
    };

    home.file.".config/hypr/hypridle.conf".text = ''
      general {
        lock_cmd = notify-send "lock!"          # dbus/sysd lock command (loginctl lock-session)
        unlock_cmd = notify-send "unlock!"      # same as above, but unlock
        before_sleep_cmd = notify-send "Zzz"    # command ran before sleep
        after_sleep_cmd = notify-send "Awake!"  # command ran after sleep
        ignore_dbus_inhibit = false             # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
      }

      listener {
          timeout = 600                                                        # in seconds
          on-timeout = hyprctl dispatch dpms off # notify-send "You are idle!" # command to run when timeout has passed
          on-resume = hyprctl dispatch dpms on # notify-send "Welcome back!"   # command to run when activity is detected after timeout has fired.
      }
    '';

    home.pointerCursor = {
      gtk.enable = true;
      # x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };

    gtk = {
      enable = true;
      cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 16;
      };

      theme = {
        package = pkgs.kdePackages.breeze-gtk;
        name = "Breeze-Dark";
      };

      iconTheme = {
        package = pkgs.kdePackages.breeze-icons;
        name = "Breeze-Dark";
      };

      font = {
        name = "FiraCode Nerd Font";
        size = 11;
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;

      systemd = {
        enable = true;
        variables = ["--all"];
      };
      xwayland.enable = true;
      plugins = mkIf cfg.tablet [
        inputs.hyprgrass.packages.${pkgs.system}.default

        # optional integration with pulse-audio, see examples/hyprgrass-pulse/README.md
        inputs.hyprgrass.packages.${pkgs.system}.hyprgrass-pulse
      ];
      settings = {
        monitor = [
          ", preferred, auto, 1"

          ## Internal Monitors
          # "desc:Sharp Corporation 0x1517, 2560×1600@60Hz, auto, 1" # XPS Display lesser resolution (mode nor avaiable)
          "desc:Sharp Corporation 0x1517, preferred, auto, 2" # XPS Display
          "desc:LG Display 0x0555, preferred, auto, 1.5" # Surface Pro7 Display

          ## Home
          "desc:BNQ BenQ GL2450H F9F05686019, preferred, auto, 1" # HomeMain
          "desc:AOC 1601W MMEL1JA000075,preferred,auto-down,1" # PortMonitor

          ## Eltern
          "desc:Samsung Electric Company C34J79x HTRM800858,3440x1440@99.98Hz,auto-left,1"
        ];

        env =
          [
            "XCURSOR_SIZE,16"
          ]
          ++ optionals cfg.nvidia_envs [
            # hybrid GPU hyprland prio intel, nvidia as fallback
            # "WLR_DRM_DEVICES,/dev/dri/card0"
            # "DRI_PRIME,1"
            "AQ_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0"

            "LIBVA_DRIVER_NAME,nvidia"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
            "NVD_BACKEND,direct"
            "WLR_RENDERER_ALLOW_SOFTWARE, 1"

            # "__EGL_VENDOR_LIBRARY_FILENAMES,/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json"
          ];

        exec-once =
          [
            "dbus-update-activation-environment --systemd --all"
            "brightnessctl set 40%"
            "wl-paste --watch cliphist store"
            "sudo xremap ~/.config/xremap/config.yml"
            "hyprpaper"
            "hypridle"
            "quickshell"
            "sleep 2"
            "ulauncher --hide-window --no-window-shadow"
          ]
          ++ optionals cfg.virtKeyboard ["wvkbd-mobintl --hidden"]
          ++ optionals (cfg.exec-once-services != []) cfg.exec-once-services
          ++ [
            "[workspace 7] zen"
            "sleep 2"
            "[workspace 1] ghostty -e tmux -2 new -Asdefault"
          ]
          ++ optionals (cfg.exec-once-apps != []) cfg.exec-once-apps;

        input = {
          kb_layout = "de";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";
          follow_mouse = 1;

          force_no_accel = true;
          sensitivity = -0.5;

          touchpad = {
            disable_while_typing = true;
            natural_scroll = true;
            scroll_factor = 0.5;
            clickfinger_behavior = true;
            tap-to-click = true;
            # drag_3fg = 3; # Not yet in HomeManager
          };
        };

        general = {
          gaps_in = 2;
          gaps_out = 4;
          border_size = 2;

          "col.active_border" = "rgba(${config.colorScheme.palette.base0E}ff) rgba(${config.colorScheme.palette.base06}ff) 60deg";
          "col.inactive_border" = "rgba(${config.colorScheme.palette.base02}ff)";

          layout = "dwindle";
        };

        cursor = {
          inactive_timeout = 60;
        };

        decoration = {
          rounding = 8;
          blur = {
            enabled = true;
            size = 6;
            passes = 2;
            new_optimizations = true;
            ignore_opacity = true;
            xray = true;
          };
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          fullscreen_opacity = 1.0;

          shadow = {
            enabled = true;
            range = 30;
            render_power = 3;
            color = "0x66000000";
          };
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;

          smart_split = false;
          smart_resizing = true;

          special_scale_factor = 0.95;
        };

        master = {
          new_status = "master";
        };

        gesture = [
          "3, horizontal, workspace"
        ];

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        animations = {
          enabled = true;
          bezier = [
            "wind, 0.05, 0.9, 0.1, 1.05"
            "winIn, 0.1, 1.1, 0.1, 1.1"
            "winOut, 0.3, -0.3, 0, 1"
            "liner, 1, 1, 1, 1"
          ];
          animation = [
            "windows, 1, 6, wind, slide"
            "windowsIn, 1, 6, winIn, slide"
            "windowsOut, 1, 5, winOut, slide"
            "windowsMove, 1, 5, wind, slide"
            "border, 1, 1, liner"
            "borderangle, 1, 30, liner, loop"
            "fade, 1, 10, default"
            "workspaces, 1, 5, wind"
          ];
        };

        # layerrule = [
        #   "blur, launcher"
        #   "blur, notifications"
        #   "noanim,selection"
        #   "blur, waybar"
        #   "blurpopups, waybar"
        # ];

        "$mainMod" = "SUPER";

        bind = [
          "$mainMod, RETURN, exec, ghostty "
          "$mainMod SHIFT, RETURN, exec, ghostty -e tmux a"
          "$mainMod SHIFT, X, exit"

          "$mainMod, Q, killactive"
          "$mainMod, F, fullscreen, 0"
          "$mainMod, M, fullscreen, 1"
          "$mainMod SHIFT, F, togglefloating"
          "$mainMod, V, togglesplit"

          # "$mainMod ALT, SPACE, exec, fuzzel"
          "ALT, SPACE, exec, ulauncher-toggle"
          "ALT SHIFT, SPACE, exec, ulauncher --no-window-shadow"
          # "$mainMod, SPACE, exec, ~/.config/scripts/applauncher.sh"
          "$mainMod, E, exec, thunar "
          "$mainMod SHIFT, E, exec, ghostty -e yazi"
          "$mainMod, B, exec, zen" # __EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json zen"
          "$mainMod SHIFT, B, exec, brave"

          "$mainMod CTRL, P, exec, wlogout"
          # "$mainMod, PRINT, exec, ~/.config/scripts/grim.sh"
          # "$mainMod SHIFT, W, exec, ~/.config/scripts/updatewal-swww.sh"
          # "$mainMod, W, exec, rofi-wifi-menu"
          # "$mainMod CTRL, W, exec, ~/.config/scripts/wallpaper-swww.sh"
          # "$mainMod CTRL, RETURN, exec, ~/.config/scripts/applauncher.sh"
          # "$mainMod SHIFT, B, exec, ~/.config/waybar/launch.sh"
          # "$mainMod CTRL, F, exec, ~/.config/scripts/filemanager.sh"
          # "$mainMod CTRL, C, exec, ~/.config/scripts/cliphist.sh"

          # Global hotkeys
          # "CTRL SHIFT, M, pass, ^(discord)$" # Not working -.-

          # Grimblast binds
          ", Print, exec, grimblast save output ~/Pictures/Screenshots/$(date +%s_grimblast).png"
          "SHIFT, Print, exec, grimblast save active ~/Pictures/Screenshots/$(date +%s_grimblast).png"
          "CTRL, Print, exec, grimblast save area ~/Pictures/Screenshots/$(date +%s_grimblast).png"

          # Switch workspaces with mainMod + [0-9]
          "$mainMod, 1, exec, ${pkgs.bash}/bin/bash ${customDispatch}/bin/customDispatch 1"
          "$mainMod, 2, exec, ${pkgs.bash}/bin/bash ${customDispatch}/bin/customDispatch 2"
          "$mainMod, 3, exec, ${pkgs.bash}/bin/bash ${customDispatch}/bin/customDispatch 3"
          "$mainMod, 4, exec, ${pkgs.bash}/bin/bash ${customDispatch}/bin/customDispatch 4"
          "$mainMod, 5, exec, ${pkgs.bash}/bin/bash ${customDispatch}/bin/customDispatch 5"
          "$mainMod, 6, exec, ${pkgs.bash}/bin/bash ${customDispatch}/bin/customDispatch 6"
          "$mainMod, 7, exec, ${pkgs.bash}/bin/bash ${customDispatch}/bin/customDispatch 7"
          "$mainMod, 8, exec, ${pkgs.bash}/bin/bash ${customDispatch}/bin/customDispatch 8"
          "$mainMod, 9, exec, ${pkgs.bash}/bin/bash ${customDispatch}/bin/customDispatch 9"
          "$mainMod, 0, exec, ${pkgs.bash}/bin/bash ${customDispatch}/bin/customDispatch 10"
          "$mainMod, a, togglespecialworkspace"

          # Switch workspaces, while keeping the asigned Monitor with mainMod + CTRL + [0-9]
          "$mainMod CTRL, 1, workspace, 1"
          "$mainMod CTRL, 2, workspace, 2"
          "$mainMod CTRL, 3, workspace, 3"
          "$mainMod CTRL, 4, workspace, 4"
          "$mainMod CTRL, 5, workspace, 5"
          "$mainMod CTRL, 6, workspace, 6"
          "$mainMod CTRL, 7, workspace, 7"
          "$mainMod CTRL, 8, workspace, 8"
          "$mainMod CTRL, 9, workspace, 9"
          "$mainMod CTRL, 0, workspace, 10"
          # "$mainMod, a, togglespecialworkspace"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"
          "$mainMod SHIFT, a, movetoworkspacesilent, special"

          # Move active window to a workspace silently with mainMod + SHIFT + CTRL + [0-9]
          "$mainMod SHIFT CTRL, 1, movetoworkspacesilent, 1"
          "$mainMod SHIFT CTRL, 2, movetoworkspacesilent, 2"
          "$mainMod SHIFT CTRL, 3, movetoworkspacesilent, 3"
          "$mainMod SHIFT CTRL, 4, movetoworkspacesilent, 4"
          "$mainMod SHIFT CTRL, 5, movetoworkspacesilent, 5"
          "$mainMod SHIFT CTRL, 6, movetoworkspacesilent, 6"
          "$mainMod SHIFT CTRL, 7, movetoworkspacesilent, 7"
          "$mainMod SHIFT CTRL, 8, movetoworkspacesilent, 8"
          "$mainMod SHIFT CTRL, 9, movetoworkspacesilent, 9"
          "$mainMod SHIFT CTRL, 0, movetoworkspacesilent, 10"
          # "$mainMod SHIFT, a, movetoworkspacesilent, special"

          # Scroll through existing workspaces with mainMod + scroll
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"

          # Tab through existing workspaces with mainMod + TAB
          "$mainMod, TAB, workspace, e+1"
          "$mainMod SHIFT, TAB, workspace, e-1"

          # Move focus with mainMod + arrow keys
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          # Move focus with mainMod + arrow keys
          "$mainMod, H, movefocus, l"
          "$mainMod, L, movefocus, r"
          "$mainMod, K, movefocus, u"
          "$mainMod, J, movefocus, d"

          # Move window with mainMod + SHIFT + arrow keys
          "$mainMod SHIFT, left, movewindow, l"
          "$mainMod SHIFT, right, movewindow, r"
          "$mainMod SHIFT, up, movewindow, u"
          "$mainMod SHIFT, down, movewindow, d"

          # Move window with mainMod + SHIFT + arrow keys
          "$mainMod SHIFT, H, movewindow, l"
          "$mainMod SHIFT, L, movewindow, r"
          "$mainMod SHIFT, K, movewindow, u"
          "$mainMod SHIFT, J, movewindow, d"

          # Move focus to the next monitor
          "$mainMod CONTROL, period, focusmonitor, +1"
        ];

        "$resizeConst" = 50;

        binde = [
          # Brightness
          ", xf86monbrightnessup, exec, brightnessctl set +5% && notify-send 'Brightness Up!'"
          ", xf86monbrightnessdown, exec, brightnessctl set 5%- && notify-send 'Brightness Down!'"

          # Audio
          ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && notify-send 'Volume Up!'"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && notify-send 'Volume Down!'"

          # Resize window with mainMod + ALT + arrow keys
          "$mainMod ALT, left, resizeactive, -$resizeConst 0"
          "$mainMod ALT, right, resizeactive, $resizeConst 0"
          "$mainMod ALT, up, resizeactive, 0 -$resizeConst"
          "$mainMod ALT, down, resizeactive, 0 $resizeConst"

          # Resize window with mainMod + ALT + arrow keys
          "$mainMod ALT, H, resizeactive, -$resizeConst 0"
          "$mainMod ALT, L, resizeactive, $resizeConst 0"
          "$mainMod ALT, K, resizeactive, 0 -$resizeConst"
          "$mainMod ALT, J, resizeactive, 0 $resizeConst"
        ];

        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        bindl = [
          ", xf86audiomute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

          # trigger when the lid is up
          ",switch:off:Lid Switch,exec,hyprctl dispatch dpms on eDP-1"
          # trigger when the lid is down
          ",switch:on:Lid Switch,exec,hyprctl dispatch dpms off eDP-1 && hyprlock -F -i ~/.cache/wallpaper --effect-blur 10x5 --clock --indicator"
        ];

        workspace = [
          # No Gap if only 1 Window is active
          "w[tv1], gapsout:0, gapsin:0"
          "f[1], gapsout:0, gapsin:0"
        ];

        windowrule = [
          # No Gap if only 1 Window is active
          "bordersize 0, floating:0, onworkspace:w[tv1]"
          # "rounding 0, floating:0, onworkspace:w[tv1]"
          "bordersize 0, floating:0, onworkspace:f[1]"
          # "rounding 0, floating:0, onworkspace:f[1]"

          # Example rule for a virtual keyboard (replace with your keyboard's class/title)
          # "float, class:onboard"
          # "size 50% 20%, class:onboard " # Example size, adjust as needed
          # "move 50%-25% 10%, class:onboard " # Example position, adjust as needed
          # "stayfocused, class:onboard"
          # "noblur, class:onboard" # or use size:0 to disable blur
          # "pin, class:onboard" # show it on all workspaces
          # "workspace 10, class:onboard, noinitialfocus" # open it on workspace 10 (not stealing focus)

          "float,class:^(pavucontrol)$"
          "size 1000 600,class:^(pavucontrol)$"
          "move 400 400,class:^(pavucontrol)$"

          "float,class:^(blueman-manager)$"
          "size 1000 600,class:^(blueman-manager)$"

          "float,class:^(thunar)$"
          "size 1000 600,class:^(thunar)$"

          "float,class:^(Extension: (Bitwarden Password Manager) - Bitwarden — Zen Browser)$"

          "float,class:^(feh)$"
          "move 400 400,class:^(feh)$"
          "float,class:^(mpv)$"
          # "size 640 360,class:^(mpv)$"
          "move 400 400,class:^(mpv)$"

          "workspace 8, class:^(Spotify)$"
          "workspace 8, class:^(com.github.wwmm.easyeffects)$"

          "workspace 9, class:^(org.telegram.desktop)$"
          "workspace 9, class:^(discord)$"
          "workspace 9, class:^(teams-for-linux)$"
          "workspace 9, class:^(whatsapp-for-linux)$"

          "workspace 10, title:(Fyne App -)(.*)"
          # "float, title:(Fyne App -)(.*)"
          # "center, title:(Fyne App -)(.*)"
          "workspace 10, title:(Dev: )(.*)"
          "workspace 10, class:^(Ebitengine-Application)$"

          "workspace 10, title:^(Parsec)$"
          "workspace 10, class:^(virt-manager)$"
          "float, title:^(Emulator)$"

          "float, class:^(org.kde.kcalc)$"
          "float, class:^(org.gnome.Calculator)$"

          "float, title:^(pulsemixer)$"
          "move 1410 62, title:^(pulsemixer)$"
          "pin, title:^(pulsemixer)$"

          "float, title:^(nmtui)$"
          "move 1410 62, title:^(nmtui)$"
          "pin, title:^(nmtui)$"

          "float, title:^(bluetuith)$"
          "move 1410 62, title:^(bluetuith)$"
          "pin, title:^(bluetuith)$"

          # Open gnome-calendar at the top right corner
          "float, class:^(org.gnome.Calendar)$"
          "size 390 600, class:^(org.gnome.Calendar)$"
          "move 1520 62, class:^(org.gnome.Calendar)$"
          "pin, class:^(org.gnome.Calendar)$"

          # Firefox Picture-in-picture
          "float, class:^(firefox)$, title:^(Picture-in-picture)$"
          "move 10 830, class:^(firefox)$, title:^(Picture-in-picture)$"
          "size 427 240, class:^(firefox)$, title:^(Picture-in-picture)$"
          "pin, class:^(firefox)$, title:^(Picture-in-picture)$"

          # Kitty floating
          "float, class:^(kitty-floating)$"

          # xwaylandvideobridge workaround https://wiki.hyprland.org/Useful-Utilities/Screen-Sharing/
          "opacity 0.0 override, class:^(xwaylandvideobridge)$"
          "noanim, class:^(xwaylandvideobridge)$"
          "noinitialfocus, class:^(xwaylandvideobridge)$"
          "maxsize 1 1, class:^(xwaylandvideobridge)$"
          "noblur, class:^(xwaylandvideobridge)$"
        ];

        plugin = {
          touch_gestures = mkIf cfg.tablet {
            # The default sensitivity is probably too low on tablet screens,
            # I recommend turning it up to 4.0
            sensitivity = 4.0;

            # must be >= 3
            workspace_swipe_fingers = 3;

            # switching workspaces by swiping from an edge, this is separate from workspace_swipe_fingers
            # and can be used at the same time
            # possible values: l, r, u, or d
            # to disable it set it to anything else
            workspace_swipe_edge = "d";

            # in milliseconds
            long_press_delay = 400;

            # resize windows by long-pressing on window borders and gaps.
            # If general:resize_on_border is enabled, general:extend_border_grab_area is used for floating
            # windows
            resize_on_border_long_press = true;

            # in pixels, the distance from the edge that is considered an edge
            edge_margin = 10;

            # emulates touchpad swipes when swiping in a direction that does not trigger workspace swipe.
            # ONLY triggers when finger count is equal to workspace_swipe_fingers
            #
            # might be removed in the future in favor of event hooks
            emulate_touchpad_swipe = true;
          };
        };
      };
    };
  };
}
