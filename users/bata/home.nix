{
  config,
  lib,
  ...
}: {
  home = {
    username = lib.mkDefault "bata";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = "25.05";
  };
  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
