{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.tmux;
in {
  options.features.cli.tmux.enable = mkEnableOption "Enable tmux";

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      clock24 = true;
      prefix = "C-a";
      terminal = "screen-256color";
      baseIndex = 1;
      escapeTime = 10;
      historyLimit = 5000;
      mouse = true;
      newSession = true;
      keyMode = "vi";
      sensibleOnTop = false;
      extraConfig = ''
        set -g focus-events on
        set -sa terminal-features ',screen-256color:RGB'
        set -ga terminal-overrides ',screen-254color:Tc'
        set -g status-position top

        unbind %
        unbind h
        bind h split-window -h

        unbind '"'
        unbind v
        bind v split-window -v

        unbind ^T
        bind ^T select-pane -t :.+

        unbind r
        bind r source-file ~/.config/tmux/tmux.conf

        # bind -r j resize-pane -D 5
        # bind -r k resize-pane -U 5
        # bind -r l resize-pane -R 5
        # bind -r h resize-pane -L 5

        bind -r m resize-pane -Z

        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind-key -T copy-mode-vi 'y' send -X copy-selection
        unbind -T copy-mode-vi MouseDragEnd1Pane # don't exit copy mode when dragging with mouse
      '';
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = vim-tmux-navigator;
        }
        {
          plugin = resurrect;
          extraConfig = ''
            resurrect_dir='/home/bata/.tmux/resurrect'
            set -g @resurrect-dir $resurrect_dir
            # set -g @resurrect-hook-post-save-all ‘target=$(readlink -f $resurrect_dir/last); sed “s| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g” $target | sponge $target’
            set -g @resurrect-capture-pane-contents 'on'
          '';
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-save-interval '5'
            set -g @continuum-restore 'on'
          '';
        }
        {
          plugin = rose-pine;
          extraConfig = ''
            set -g @rose_pine_variant 'main' # Options are 'main', 'moon' or 'dawn'

            set -g @rose_pine_host 'on' # Enables hostname in the status bar
            set -g @rose_pine_date_time "" # It accepts the date UNIX command format (man date for info)
            set -g @rose_pine_user 'on' # Turn on the username component in the statusbar
            set -g @rose_pine_directory 'on' # Turn on the current folder component in the status bar
            set -g @rose_pine_bar_bg_disable 'on' # Disables background color, for transparent terminal emulators
            # If @rose_pine_bar_bg_disable is set to 'on', uses the provided value to set the background color
            # It can be any of the on tmux (named colors, 256-color set, `default` or hex colors)
            # See more on http://man.openbsd.org/OpenBSD-current/man1/tmux.1#STYLES
            set -g @rose_pine_bar_bg_disabled_color_option 'default'

            set -g @rose_pine_only_windows 'on' # Leaves only the window module, for max focus and space
            set -g @rose_pine_disable_active_window_menu 'on' # Disables the menu that shows the active window on the left

            set -g @rose_pine_default_window_behavior 'on' # Forces tmux default window list behaviour
            set -g @rose_pine_show_current_program 'on' # Forces tmux to show the current running program as window name
            set -g @rose_pine_show_pane_directory 'on' # Forces tmux to show the current directory as window name
            # Previously set -g @rose_pine_window_tabs_enabled

            # Example values for these can be:
            set -g @rose_pine_left_separator ' > ' # The strings to use as separators are 1-space padded
            set -g @rose_pine_right_separator ' < ' # Accepts both normal chars & nerdfont icons
            set -g @rose_pine_field_separator ' | ' # Again, 1-space padding, it updates with prefix + I
            set -g @rose_pine_window_separator ' - ' # Replaces the default `:` between the window number and name

            # These are not padded
            set -g @rose_pine_session_icon '' # Changes the default icon to the left of the session name
            set -g @rose_pine_current_window_icon '' # Changes the default icon to the left of the active window name
            set -g @rose_pine_folder_icon '' # Changes the default icon to the left of the current directory folder
            set -g @rose_pine_username_icon '' # Changes the default icon to the right of the hostname
            set -g @rose_pine_hostname_icon '󰒋' # Changes the default icon to the right of the hostname
            set -g @rose_pine_date_time_icon '󰃰' # Changes the default icon to the right of the date module
            set -g @rose_pine_window_status_separator "  " # Changes the default icon that appears between window names

            # Very beta and specific opt-in settings, tested on v3.2a, look at issue #10
            set -g @rose_pine_prioritize_windows 'on' # Disables the right side functionality in a certain window count / terminal width
            set -g @rose_pine_width_to_hide '80' # Specify a terminal width to toggle off most of the right side functionality
            set -g @rose_pine_window_count '5' # Specify a number of windows, if there are more than the number, do the same as width_to_hide
          '';
        }
        # {
        #   plugin = dracula;
        #   extraConfig = ''
        #     set -g @dracula-show-powerline true
        #     set -g @dracula-show-left-icon session
        #     set -g @dracula-show-left-sep 
        #     set -g @dracula-show-right-sep 
        #     set -g @dracula-refresh-rate 5
        #     set -g @dracula-fixed-location "Mülheim an der Ruhr, Germany"
        #     set -g @dracula-plugins "cpu-usage ram-usage" # weather"
        #     set -g @dracula-show-fahrenheit false
        #     set -g @dracula-cpu-display-load true
        #     set -g @dracula-show-flags true
        #     set -g @dracula-show-left-icon session
        #   '';
        # }
      ];
    };
  };
}
