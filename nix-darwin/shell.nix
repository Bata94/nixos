{pkgs, ...}: let
  shellAliases = {
    tmux = "tmux -2";
    td = "tmux -2 new -Asdefault";

    ls = "colorls";
    ll = "colorls -l";
    la = "colorls -la";
    ".." = "cd ..";

    lg = "lazygit";
    ld = "lazydocker";
    "nix develop" = "nix develop --command zsh";

    dc = "docker compose";
    cat = "bat";
  };
in {
  programs.bash = {
    inherit shellAliases;
    enable = true;
  };

  programs.zsh = {
    inherit shellAliases;
    initExtra = ''
      export PATH="$PATH:$HOME/go/bin"

      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=4"

      export NVM_DIR="$HOME/.nvm"

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

  # Collection of useful CLI apps
  home.packages = with pkgs; [
    dwt1-shell-color-scripts
    colorls
    # disfetch
    # neofetch
    lolcat
    cowsay
    # onefetch
    # starfetch
    lazydocker
    # unzip
    # p7zip
    # cava
    # gnugrep
    # gnused
    # killall
    libnotify
    timer
    bat
    eza
    fd
    bottom
    ripgrep
    rsync
    tmux
    htop
    btop
    # hwinfo
    unzip
    # brightnessctl
    # w3m
    fzf
    pandoc
    # pciutils
    jq
    curl
    texinfo
    libffi
    zlib
    nodePackages.ungit
    lazygit
  ];

  programs.bat.enable = true;
  programs.fzf.enable = true;
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd"
    ];
  };
}
