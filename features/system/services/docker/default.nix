{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.system.services.docker;
in {
  options.features.system.services.docker.enable = mkEnableOption "Enable docker";
  options.features.system.services.docker.compose2nix = mkEnableOption "Enable compose2nix";

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      storageDriver = "overlay2";
      autoPrune.enable = true;
      logDriver = "json-file";
    };
    users.users.bata.extraGroups = ["docker"];
    virtualisation.oci-containers.backend = "docker";

    # TODO: check if nvidia is enabled
    virtualisation.docker.daemon.settings.features.cdi = true;

    environment.systemPackages =
      [
        pkgs.lazydocker
      ]
      ++ optionals cfg.compose2nix [
        inputs.compose2nix.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
  };
}
