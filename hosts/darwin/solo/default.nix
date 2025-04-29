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

  # imports = [ ./system.nix ];

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
      # "google-chrome"
      "ghostty"
      "zen-browser"
    ];
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
    go
    gotools
    gopls
    go-outline
    gopls
    gopkgs
    gocode-gomod
    godef
    golint
    docker
    docker-compose
    wget
    iperf3
    neofetch
    rsync
    nmap
    jq
    yq
    just
    ripgrep
    sqlite
    pwgen
    # inputs.agenix.packages."${system}".default
    spotify
    google-cloud-sdk
    deploy-rs
    nixpkgs-fmt
    nixfmt-rfc-style
  ];

  services.nix-daemon.enable = lib.mkForce true;
  security.pam.enableSudoTouchIdAuth = true;
  nix.extraOptions = ''extra-platforms = x86_64-darwin aarch64-darwin'';

  system.stateVersion = 4;
}
