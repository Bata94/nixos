{pkgs, ...}: {
  imports = [
    ./android.nix
    ./c.nix
    ./flutter.nix
    ./go.nix
    ./java.nix
    ./lua.nix
    ./nodeJS.nix
    ./python.nix
    ./rust.nix
  ];

  home.packages = with pkgs; [
    opencode
  ];
}
