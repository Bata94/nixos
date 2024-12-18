{
  description = "Bata NixOS Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:bata94/nixvim-conf";
    };

    colmena.url = "github:zhaofengli/colmena";
    agenix.url = "github:ryantm/agenix";

    compose2nix = {
      url = "github:aksiksi/compose2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    agenix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    overlays = import ./overlays {inherit inputs;};
    # homeManagerModules = import ./modules/home-manager;
    nixosConfigurations = {
      vm-xps-test = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/vm-xps-test
          inputs.disko.nixosModules.disko
          agenix.nixosModules.default
        ];
      };
      vm-xps-1 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/vm-xps-1
          inputs.disko.nixosModules.disko
          agenix.nixosModules.default
        ];
      };
      vm-xps-2 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/vm-xps-2
          inputs.disko.nixosModules.disko
          agenix.nixosModules.default
        ];
      };
      vm-xps-3 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/vm-xps-3
          inputs.disko.nixosModules.disko
          agenix.nixosModules.default
        ];
      };
    };
    homeConfigurations = {
      "bata@vm-xps-test" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./users/bata/vm-xps-test.nix];
      };
      "bata@vm-xps-1" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./users/bata/vm-xps-1.nix];
      };
      "bata@vm-xps-2" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./users/bata/vm-xps-2.nix];
      };
      "bata@vm-xps-3" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./users/bata/vm-xps-3.nix];
      };
    };
  };
}
