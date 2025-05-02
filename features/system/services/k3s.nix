{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.system.services.k3s;
in {
  options.features.system.services.k3s.enable = mkEnableOption "Enable k3s";

  config = mkIf cfg.enable {
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
  };
}
