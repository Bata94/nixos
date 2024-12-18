{...}: let
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
  programs.bash = {
    inherit shellAliases;
    enable = true;
  };

  programs.zsh = {
    inherit shellAliases;
    initExtra = ''
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
}
