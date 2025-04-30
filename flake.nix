{
  description = "Bata NixOS Flake";

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
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-darwin-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager-darwin = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:bata94/nixvim-conf";

    auto-aspm = {
      url = "github:notthebee/AutoASPM";
      flake = false;
    };

    colmena.url = "github:zhaofengli/colmena";
    agenix.url = "github:ryantm/agenix";

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets = {
      url = "git+ssh://git@github.com/bata94/nixos-secrets.git";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... } @ inputs: let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      coruscant = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/nixos/coruscant
          inputs.disko.nixosModules.disko
        ];
      };
    };

    homeConfigurations = {
      "bata@coruscant" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./users/bsievers/coruscant.nix];
      };
    };

    darwinConfigurations = {
      solo = nix-darwin.lib.darwinSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/darwin/solo
        ];
      };
    };
  };
}

# # homeManagerModules = import ./modules/home-manager;
# nixosConfigurations = {
# anakin = nixpkgs.lib.nixosSystem {
#   specialArgs = {inherit inputs outputs;};
#   modules = [
#     ./hosts/anakin
#     inputs.disko.nixosModules.disko
#     agenix.nixosModules.default
#   ];
# }; 
# vm-xps-test = nixpkgs.lib.nixosSystem {
#   specialArgs = {inherit inputs outputs;};
#   modules = [
#     ./hosts/vm-xps-test
#     inputs.disko.nixosModules.disko
#     agenix.nixosModules.default
#   ];
# };
# vm-xps-1 = nixpkgs.lib.nixosSystem {
#   specialArgs = {inherit inputs outputs;};
#   modules = [
#     ./hosts/vm-xps-1
#     inputs.disko.nixosModules.disko
#     agenix.nixosModules.default
#   ];
# };
# vm-xps-2 = nixpkgs.lib.nixosSystem {
#   specialArgs = {inherit inputs outputs;};
#   modules = [
#     ./hosts/vm-xps-2
#     inputs.disko.nixosModules.disko
#     agenix.nixosModules.default
#   ];
# };
# vm-xps-3 = nixpkgs.lib.nixosSystem {
#   specialArgs = {inherit inputs outputs;};
#   modules = [
#     ./hosts/vm-xps-3
#     inputs.disko.nixosModules.disko
#     agenix.nixosModules.default
#   ];
# };
# };
# homeConfigurations = {
# "bata@anakin" = home-manager.lib.homeManagerConfiguration {
#   pkgs = nixpkgs.legacyPackages."x86_64-linux";
#   extraSpecialArgs = {inherit inputs outputs;};
#   modules = [./users/bata/vm-xps-test.nix];
# };
# "bata@vm-xps-test" = home-manager.lib.homeManagerConfiguration {
#   pkgs = nixpkgs.legacyPackages."x86_64-linux";
#   extraSpecialArgs = {inherit inputs outputs;};
#   modules = [./users/bata/vm-xps-test.nix];
# };
# "bata@vm-xps-1" = home-manager.lib.homeManagerConfiguration {
#   pkgs = nixpkgs.legacyPackages."x86_64-linux";
#   extraSpecialArgs = {inherit inputs outputs;};
#   modules = [./users/bata/vm-xps-1.nix];
# };
# "bata@vm-xps-2" = home-manager.lib.homeManagerConfiguration {
#   pkgs = nixpkgs.legacyPackages."x86_64-linux";
#   extraSpecialArgs = {inherit inputs outputs;};
#   modules = [./users/bata/vm-xps-2.nix];
# };
# "bata@vm-xps-3" = home-manager.lib.homeManagerConfiguration {
#   pkgs = nixpkgs.legacyPackages."x86_64-linux";
#   extraSpecialArgs = {inherit inputs outputs;};
#   modules = [./users/bata/vm-xps-3.nix];
# };
# };
