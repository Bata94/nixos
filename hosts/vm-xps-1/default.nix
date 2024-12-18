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
    clusterInit = true;
    token = "K10c9118f420d86ef16d3439fae32db40e47ed848165fee9bad4b351129f5313e27::server:a121165383db9c674b90bbfe736fd8d8";
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
