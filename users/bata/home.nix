{
  config,
  lib,
  ...
}: {
  home = {
    username = lib.mkDefault "bata";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = "24.11";
  };
  programs.home-manager.enable = true;

  # home.sessionVariables = {
  #   EDITOR = "nvim";
  # };
}
