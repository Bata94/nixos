{
  pkgs,
  lib,
  ...
}:
with lib; let
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
    ts = "${tmuxSessionizer}/bin/tmuxSessionizer -r ~/Projects";
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
      settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile "${PROJECT_ROOT}/user/shell/omp.json"));
    };
  };
}
