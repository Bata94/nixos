{
  imports = [
    ./home.nix
    ../common
    ../features
  ];

  features = {
    apps = {
      editor = {
        nixvim.enable = true;
      };
    };
    cli = {
      sh.enable = true;
      zoxide.enable = true;
      git.enable = true;
      tmux.enable = true;
    };
  };
}
