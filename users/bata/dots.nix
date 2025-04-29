{ inputs, ... }:
let
  home = {
    username = "bata";
    homeDirectory = "/home/bata";
    stateVersion = "23.11";
    packages = [ inputs.nixvim.packages."aarch64-darwin".default ];
  };
in
{

  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home = home;

  imports = [
    # ../../dots/zsh/default.nix
    # ../../dots/nvim/default.nix
    # ../../dots/neofetch/default.nix
    # ./packages.nix
    ./gitconfig.nix
  ];

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";
}
