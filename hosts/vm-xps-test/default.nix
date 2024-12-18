{pkgs, ...}: {
  imports = [
    ../common
    ./configuration.nix

    ../features/services/docker
    # TODO: Compose2nix not working via remote deploy
    # ../features/services/docker/compose/postgres.nix

    ../features/desktop

    # ../features/services/k3s.nix
    # ./secrets.nix
    # ./services
    # ./specialisations.nix
  ];
  # extraServices.podman.enable = true;

  features.desktop = {
    wm.kde.enable = true;
  };
}
