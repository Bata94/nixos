{
  config,
  lib,
  # pkgs,
  ...
}: {
  home.username = lib.mkDefault "your-name";
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";

  home.stateVersion = "24.11";
  # home.packages = with pkgs; [];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
