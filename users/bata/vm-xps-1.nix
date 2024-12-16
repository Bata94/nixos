{
  imports = [
    ./home.nix
    # ./dotfiles
    ../common
    ../features/cli
  ];

  # features = {
  #   cli = {
  #     fish.enable = true;
  #     fzf.enable = true;
  #     neofetch.enable = true;
  #   };
  # };
}
