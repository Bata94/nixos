{pkgs, ...}: {
  imports = [
    ../common
    ./configuration.nix

    # ../features/services/k3s.nix
    # ./secrets.nix
    # ./services
    # ./specialisations.nix
  ];
  # extraServices.podman.enable = true;
}
