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

  services.k3s = {
    enable = true;
    clusterInit = false;
    serverAddr = "https://vm-xps-1:6443";
    role = "server";
  };
  environment.systemPackages = with pkgs; [
    (wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        helm-s3
        helm-git
      ];
    })
  ];
}
