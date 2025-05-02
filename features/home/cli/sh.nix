{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.sh;

  shellAliases = {
    tmux = "tmux -2";
    td = "tmux -2 new -Asdefault";

    ls = "colorls";
    ll = "colorls -l";
    la = "colorls -la";
    ".." = "cd ..";

    lg = "lazygit";
    ld = "lazydocker";
    nd = "nix develop --command zsh";

    dc = "docker compose";

    kc = "kubectl";

    f = "fzf --preview 'bat --color=always --style=header,grid,numbers --line-range :500 {}'";

    cat = "bat";
    grep = "rg";
    ps = "procs";
  };
in {
  options.features.cli.sh.enable = mkEnableOption "Enable SH";
  # TODO: rm/split up installs in more feature options
  config = mkIf cfg.enable {
    programs.bat.enable = true;
    programs.fzf.enable = true;

    home.packages = with pkgs; [
      coreutils

      dwt1-shell-color-scripts
      colorls
      neofetch
      # lazygit
      # lazydocker
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
      # settings = builtins.fromJSON ./omp.json;
      useTheme = "powerlevel10k_rainbow";
    };
  };
}
