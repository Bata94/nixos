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
  options.features.system.services.docker.autoStart = mkEnableOption "Enable AutoStart";

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      # TODO: Make this settable
      enableOnBoot = false;
      storageDriver = "overlay2";
      autoPrune.enable = true;
      logDriver = "json-file";
      # rootless = {
      #   enable = true;
      #   setSocketVariable = true;
      # };
    };

    # TODO: Make this settable
    # Disable Rootless-Docker auto start on boot
    systemd.user.services.docker = {
      enable = true;
      wantedBy = lib.mkForce [];
    };

    # Disable Docker auto start on boot
    systemd.services.docker = {
      enable = true;
      wantedBy = lib.mkForce [];
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
