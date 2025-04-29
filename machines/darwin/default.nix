{ ... }:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      max-jobs = "auto";
      trusted-users = [
        "root"
        "bata"
        "@admin"
      ];
    };
  };
}
