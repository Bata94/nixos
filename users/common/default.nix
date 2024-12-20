{
  lib,
  outputs,
  pkgs,
  ...
}: {
  # imports = builtins.attrValues outputs.homeManagerModules;
  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
    };
  };
}
