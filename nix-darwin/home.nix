{
  config,
  pkgs,
  lib,
  nix-colors,
  ...
}: {
  home.stateVersion = "23.11";

  imports = [
    # nix-colors.homeManagerModules.default

    /Users/bata/Projects/personal/nix/nix-config/user/app/terminal/tmux.nix
    # /Users/bata/Projects/personal/nix/nix-config/user/app/terminal/alacritty.nix

    ./shell.nix
    ./alacritty.nix
    # /Users/bata/Projects/personal/nix/nix-config/user/shell/sh.nix
    # /Users/bata/Projects/personal/nix/nix-config/user/shell/cli-collection.nix

    # /Users/bata/Projects/personal/nix/nix-config/user/lang/android.nix
    /Users/bata/Projects/personal/nix/nix-config/user/lang/c.nix
    /Users/bata/Projects/personal/nix/nix-config/user/lang/flutter.nix
    /Users/bata/Projects/personal/nix/nix-config/user/lang/go.nix
    /Users/bata/Projects/personal/nix/nix-config/user/lang/java.nix
    # /Users/bata/Projects/personal/nix/nix-config/user/lang/lua.nix
    /Users/bata/Projects/personal/nix/nix-config/user/lang/nodeJS.nix
    /Users/bata/Projects/personal/nix/nix-config/user/lang/python.nix
    # /Users/bata/Projects/personal/nix/nix-config/user/lang/rust.nix
  ];

  # https://github.com/malob/nixpkgs/blob/master/home/default.nix

  # Direnv, load and unload environment variables depending on the current directory.
  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  # colorScheme = nix-colors.colorSchemes.dracula; # catppuccin-mocha;

  # Htop
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  home.packages = with pkgs;
    [
      # Some basics
      coreutils
      curl
      wget

      # Dev stuff
      # (agda.withPackages (p: [ p.standard-library ]))
      google-cloud-sdk
      haskellPackages.cabal-install
      haskellPackages.hoogle
      haskellPackages.hpack
      haskellPackages.implicit-hie
      haskellPackages.stack
      idris2
      jq
      typescript
      nodePackages.typescript
      nodejs
      purescript

      postgresql

      # Useful nix related tools
      cachix # adding/managing alternative binary caches hosted by Cachix
      # comma # run software from without installing it
      niv # easy dependency management for nix projects
      nodePackages.node2nix
    ]
    ++ lib.optionals stdenv.isDarwin [
      cocoapods
      m-cli # useful macOS CLI commands
    ];

  # Misc configuration files --------------------------------------------------------------------{{{
  # https://docs.haskellstack.org/en/stable/yaml_configuration/#non-project-specific-config
  home.file.".stack/config.yaml".text = lib.generators.toYAML {} {
    templates = {
      scm-init = "git";
      params = {
        author-name = "Bastian Sievers"; # config.programs.git.userName;
        author-email = "bastian.sievers@gmail.com"; # config.programs.git.userEmail;
        github-username = "bata94";
      };
    };
    nix.enable = true;
  };
}
