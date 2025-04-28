{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  environment.shellInit = ''
    ulimit -n 2048
  '';

  imports = [ ./work.nix ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
    brewPrefix = "/opt/homebrew/bin";
    caskArgs = {
      no_quarantine = true;
    };
    casks = [
      "ghostty"
      # "google-chrome"
      "tailscale"
      "zen-browser"
    ];
    brews = [];
  };
  environment.systemPackages = with pkgs; [
    (python312Full.withPackages (
      ps: with ps; [
        pip
        jmespath
        requests
        setuptools
        pyyaml
        pyopenssl
      ]
    ))
    yq
    git-lfs
    go
    gotools
    gopls
    go-outline
    gopls
    gopkgs
    gocode-gomod
    godef
    golint
    colima
    docker
    docker-compose
    wget
    git-crypt
    iperf3
    eza
    tmux
    rsync
    nmap
    jq
    yq
    just
    ripgrep
    sqlite
    pwgen
    gnupg
    # TODO:
    # inputs.agenix.packages."${system}".default
    ffmpeg
    spotify
    google-cloud-sdk
    deploy-rs
    nixpkgs-fmt
    nil
  ];

  services.nix-daemon.enable = lib.mkForce true;

  system.stateVersion = 4;
}
