{
  imports = [
    ./home.nix
    # ./dotfiles
    ../common
    ../../features/home
  ];

  features.home = {
    apps = {
      editor.nixvim.enable = true;
      terminal.ghostty.enable = true;
    };
    cli = {
      tui = {
        filebrowser.yazi.enable = true;
        lazygit.enable = false;
        lazydocker.enable = false;
      };
      git.enable = true;
      sh.enable = true;
      tmux.enable = true;
      zoxide.enable = true;
    };
  # development = {};
    wm = {
      dunst.enable = true;
      hyprland = {
        enable = true;
      };
    };
  };
}
