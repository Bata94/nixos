{...}: {
  imports = [
    ../../../features/home
  ];

  features = {
    apps = {
      editor.nixvim.enable = true;
      terminal.ghostty.enable = true;
    };
    cli = {
      tui = {
        filebrowser.yazi.enable = true;
        lazydocker.enable = false;
        lazygit.enable = true;
      };
      git.enable = true;
      sh.enable = true;
      tmux.enable = true;
      zoxide.enable = true;
    };
  };
}
