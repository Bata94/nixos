{ inputs, lib, config, pkgs, ... }:
{
  # age.secrets.gitIncludes = {
  #   file = "${inputs.secrets}/gitIncludes.age";
  #   path = "$HOME/.config/git/includes";
  # };

  programs.git = {
    enable = true;
    userName = "Bata94";
    userEmail = "bastian.sievers@gmail.com";

    
    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "store";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };

    delta = {
      enable = true;
      options = {
        line-numbers = true;
        side-by-side = true;
        diff-so-fancy = true;
        navigate = true;
      };
    };
    # extraConfig = {
    #   core = {
    #     sshCommand = "ssh -o 'IdentitiesOnly=yes' -i ~/.ssh/notthebee";
    #   };
    # };
    # includes = [
    #   {
    #     path = "~" + (lib.removePrefix "$HOME" config.age.secrets.gitIncludes.path);
    #     condition = "gitdir:~/Workspace/Projects/";
    #   }
    # ];
  };

  home.packages = [ pkgs.gh ]; # pkgs.git-lfs
}
