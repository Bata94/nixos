{
  pkgs,
  ...
}: {
  imports = [
    ./sh.nix
    ./zoxide.nix
    ./nixvim.nix
    ./git.nix
  ];

  programs.bat.enable = true;
  programs.fzf.enable = true;

  home.packages = with pkgs; [
    coreutils

    dwt1-shell-color-scripts
    colorls
    neofetch
    lazygit
    lazydocker
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
    hwinfo
    unzip
    w3m
    pandoc
    pciutils
    jq
    curl
    texinfo
    libffi
    zlib

    gcc
    httpie
    procs
    tldr
    zip
  ];
}
