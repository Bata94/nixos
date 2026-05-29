{inputs, ...}: {
  imports = [
    ./home.nix
    ../common
    ../../features/home

    inputs.sops-nix.homeManagerModules.sops
  ];

  features.home = {
    apps = {
      editor = {
        nixvim.enable = true;
      };
    };
    cli = {
      sh.enable = true;
      zoxide.enable = true;
      git.enable = true;
    };
  };
}
