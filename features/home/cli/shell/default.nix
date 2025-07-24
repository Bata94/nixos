{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  ompSet = builtins.readFile ./omp.json;
  tmuxSessionizer = pkgs.writeShellScriptBin "tmuxSessionizer" (builtins.readFile ./tmux-sessionizer.sh);
  cheatSheet = pkgs.writeShellScriptBin "cheatSheet" ''
    #! /usr/bin/env bash

    # TODO: query options from cht.sh directly
    languages=$(echo "golang typescript rust python flutter dart nix" | tr " " "\n")
    core_utils=$(echo "find xargs sed awk make just" | tr " " "\n")
    selected=$(echo -e "$languages\n$core_utils" | fzf)

    read -p "Query: " query

    if echo "$languages" | grep -qs $selected; then
      tmux split-window -h bash -c "curl cht.sh/$selected/$(echo $query | tr " " "+") | less"
    else
      curl cht.sh/$selected~$query
    fi
  '';
  shellAliases = {
    tmux = "tmux -2";
    td = "tmux -2 new -Asdefault";
    ta = "tmux a";
    ts = "${tmuxSessionizer}/bin/tmuxSessionizer -r ~/Projects/work ~/Projects/personal";
    cs = "${cheatSheet}/bin/cheatSheet";
    y = "yazi";

    ls = "colorls";
    ll = "colorls -l";
    la = "colorls -la";
    ".." = "cd ..";

    lg = "lazygit";
    ld = "lazydocker";
    nd = "nix develop --command zsh";

    dc = "docker compose";
    cat = "bat";

    kc = "kubectl";

    f = "fzf --preview 'bat --color=always --style=header,grid,numbers --line-range :500 {}'";
  };
  PROJECT_ROOT = builtins.getEnv "PWD";

  cfg = config.features.home.cli.sh;
in {
  options.features.home.cli.sh.enable = mkEnableOption "Enable SH";
  # TODO: rm/split up installs in more feature options
  config = mkIf cfg.enable {
    programs.bat.enable = true;
    programs.fzf.enable = true;

    home.packages = with pkgs; [
      coreutils

      dwt1-shell-color-scripts
      colorls
      neofetch
      unzip
      p7zip
      gnugrep
      gnused
      killall
      libnotify
      timer
      eza
      fd
      bottom
      ripgrep
      rsync
      htop
      btop
      # hwinfo
      unzip
      w3m
      pandoc
      # pciutils
      jq
      curl
      texinfo
      libffi
      zlib

      gcc
      httpie
      procs
      tldr
      # zip
    ];

    programs.bash = {
      inherit shellAliases;
      enable = true;
    };

    programs.zsh = {
      inherit shellAliases;
      initContent = ''
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=4"

        function fzf-nvim {
          local file=$(f < /dev/tty)
          if [[ -n $file ]]; then
            nvim "$file"
          fi
        }
        zle -N fzf-nvim
        bindkey '^E' fzf-nvim;

        colorscript random
      '';
      enable = true;
      autocd = true;
      autosuggestion.enable = true;
      syntaxHighlighting = {enable = true;};
    };

    # TODO: Customize :)

    programs.oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      settings = builtins.fromJSON (builtins.unsafeDiscardStringContext ompSet);
    };

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

        # switch windows alt+number
        bind-key -n M-0 select-window -t :0
        bind-key -n M-1 select-window -t :1
        bind-key -n M-2 select-window -t :2
        bind-key -n M-3 select-window -t :3
        bind-key -n M-4 select-window -t :4
        bind-key -n M-5 select-window -t :5
        bind-key -n M-6 select-window -t :6
        bind-key -n M-7 select-window -t :7
        bind-key -n M-8 select-window -t :8
        bind-key -n M-9 select-window -t :9

        bind-key -n M-s popup -w 80% -h 80% -E '${tmuxSessionizer}/bin/tmuxSessionizer -r ~/Projects/work ~/Projects/personal > ~/ts.log'
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
      ];
    };
  };
}
