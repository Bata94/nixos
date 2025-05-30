# GH: NotTheBee (Wolfgang)
inputs:
let
  homeManagerCfg = userPackages: extraImports: {
    home-manager.useGlobalPkgs = false;
    home-manager.extraSpecialArgs = {
      inherit inputs;
    };
    home-manager.users.bata.imports = [

      # ./users/bata/dots.nix
      # ./users/bata/age.nix
    ] ++ extraImports;
    home-manager.backupFileExtension = "bak";
    home-manager.useUserPackages = userPackages;
  };
in
{

  mkDarwin = machineHostname: nixpkgsVersion: extraHmModules: extraModules: {
    darwinConfigurations.${machineHostname} = inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        # "${inputs.secrets}/default.nix"
        # inputs.agenix.darwinModules.default
        ./hosts/features/darwin
        # ./machines/darwin/${machineHostname}
        inputs.home-manager-darwin.darwinModules.home-manager
        (inputs.nixpkgs-darwin.lib.attrsets.recursiveUpdate (homeManagerCfg true extraHmModules) {
          home-manager.users.bata.home.homeDirectory =
            inputs.nixpkgs-darwin.lib.mkForce "/Users/bata";
        })
      ];
    };
  };
  mkNixos = machineHostname: nixpkgsVersion: extraModules: rec {
    deploy.nodes.${machineHostname} = {
      hostname = machineHostname;
      profiles.system = {
        user = "root";
        sshUser = "bata";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos nixosConfigurations.${machineHostname};
      };
    };
    nixosConfigurations.${machineHostname} = nixpkgsVersion.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        # vars = import ./machines/nixos/vars.nix;
      };
      modules = [
        # ./homelab
        # ./machines/nixos/_common
        # ./machines/nixos/${machineHostname}
        # ./modules/email
        # ./modules/tg-notify
        # ./modules/auto-aspm
        # ./modules/mover
        # "${inputs.secrets}/default.nix"
        # inputs.agenix.nixosModules.default
        # ./users/bata
        (homeManagerCfg false [ ])
      ] ++ extraModules;
    };
  };
  mkMerge = inputs.nixpkgs.lib.lists.foldl' (
    a: b: inputs.nixpkgs.lib.attrsets.recursiveUpdate a b
  ) { };
}
