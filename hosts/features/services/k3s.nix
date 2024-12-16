{pkgs, ...}: {
  services.k3s = {
    enable = true;
    clusterInit = true;
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
