{
  nixConfig = {
    trusted-substituters = [
      "https://cachix.cachix.org"
      "https://nixpkgs.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-darwin-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:Bata94/nixvim-conf";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-darwin = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    auto-aspm = {
      url = "github:notthebee/AutoASPM";
      flake = false;
    };
    # agenix = {
    #   url = "github:ryantm/agenix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # recyclarr-configs = {
    #   url = "github:recyclarr/config-templates";
    #   flake = false;
    # };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    # adios-bot = {
    #   url = "github:notthebee/adiosbot";
    #   flake = false;
    # };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # secrets = {
    #   url = "git+ssh://git@github.com/notthebee/nix-private.git";
    #   flake = false;
    # };
    # jovian = {
    #   url = "github:Jovian-Experiments/Jovian-NixOS";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };
    # alga = {
    #   url = "github:Tenzer/alga";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };
    deploy-rs.url = "github:serokell/deploy-rs";

  };

  outputs =
    { ... }@inputs:
    let
      helpers = import ./flakeHelpers.nix inputs;
      inherit (helpers) mkMerge mkNixos mkDarwin;
    in
    mkMerge [
      (mkDarwin "solo" inputs.nixpkgs-darwin
        [
          dots/kitty
        ]
        [ ]
      )
    ];
}
