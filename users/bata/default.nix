{
  # config,
  # inputs,
  pkgs,
  ...
}:
{
  nix.settings.trusted-users = [ "bata" ];

  # age.secrets.hashedUserPassword = {
  #   file = "${inputs.secrets}/hashedUserPassword.age";
  # };

  users = {
    users = {
      bata = {
        shell = pkgs.zsh;
        uid = 1000;
        isNormalUser = true;
        # hashedPasswordFile = config.age.secrets.hashedUserPassword.path;
        extraGroups = [
          "wheel"
          "users"
          "video"
          "docker"
          "podman"
          "input"
        ];
        group = "bata";
        # openssh.authorizedKeys.keys = [
        #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKGUGMUo1dRl9xoDlMxQGb8dNSY+6xiEpbZWAu6FAbWw moe@notthebe.ee"
        # ];
      };
    };
    groups = {
      bata = {
        gid = 1000;
      };
    };
  };
  programs.zsh.enable = true;

  home.programs.gh = {
    enable = true;
  };
}
