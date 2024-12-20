{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixvim = {
      # url = "github:nix-community/nixvim";
      # url = "github:bata94/nixvim-conf";
      url = "path:/Users/bata/Projects/personal/nix/nixvim-conf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {
    self,
    nix-darwin,
    home-manager,
    nixpkgs,
    nixvim,
  }: let
    inherit (nix-darwin.lib) darwinSystem;
    inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;

    nixpkgsConfig = {
      config = {allowUnfree = true;};
      overlays =
        attrValues self.overlays
        ++ singleton (
          # Sub in x86 version of packages that don't build on Apple Silicon yet
          final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            inherit
              (final.pkgs-x86)
              idris2
              nix-index
              niv
              purescript
              ;
          })
        );
    };

    configuration = {pkgs, ...}: {
      environment.systemPackages = [
        pkgs.vim
        nixvim.packages.aarch64-darwin.default
      ];
      programs.zsh.enable = true;
      services.nix-daemon.enable = true;
      security.pam.enableSudoTouchIdAuth = true;
      nix.extraOptions = ''extra-platforms = x86_64-darwin aarch64-darwin'';

      nix.linux-builder.enable = true;
      system.defaults = {
        dock.autohide = true;
        dock.mru-spaces = false;
        finder.AppleShowAllExtensions = true;
        finder.FXPreferredViewStyle = "clmv";
        screencapture.location = "~/Pictures/screenshots";
        screensaver.askForPasswordDelay = 10;
      };

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      nix.settings = {
        experimental-features = "nix-command flakes";
        trusted-users = ["bata"];
        extra-trusted-users = ["bata"];
      };

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;
      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."MacBookBata" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          nixpkgs = nixpkgsConfig;
          # `home-manager` config
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.jun = import ./home.nix;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."MacBookBata".pkgs;
  };
}
