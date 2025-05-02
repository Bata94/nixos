{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.cli.git;
in {
  options.features.home.cli.git.enable = mkEnableOption "Enable Git";
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;

      userName = "bata";
      userEmail = "bastian.sievers@gmail.com";

      delta = {
        enable = true;
        options = {
          navigate = true;
          line-numbers = true;
          side-by-side = false;
          theme = "Nord";
        };
      };

      # will create ~/.config/git/ingore file
      # This file will be used as a global ignore file for git
      ignores = [
        ".vim-bookmarks"
        "Session.vim"
        "tags"
        ".clang-format"
        ".ccls-cache"
      ];

      extraConfig = {
        # This directive will rebase local chagnes on top of the remote branch
        # in case branches diverged instead of the defualt of creating a commit
        # on the local branch which will diverge from the remote branch.
        # using rebase is a cleaner solution and will keep the history linear.
        branch = {
          autosetuprebase = "always";
        };

        merge = {
          conflictStyle = "zdiff3";
        };
        # User and email defined in this file that is generated using sops
        # For some reason git config --global user.[name/email] shows empty but
        # executing git config user.[name/email] inside of a repo works just fine.
        # include = {
        #     path = "${config.userDefinedGlobalVariables.homeDirectory}/.config/git/credentials";
        # };
      };
    };
  };
}
