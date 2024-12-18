{
  pkgs,
  inputs,
  ...
}: {
  # hardware.nvidia-container-toolkit.enable = true;
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    storageDriver = "overlay2";
    autoPrune.enable = true;
    logDriver = "json-file";
  };
  users.users.bata.extraGroups = ["docker"];
  virtualisation.oci-containers.backend = "docker";

  environment.systemPackages = [
    inputs.compose2nix.packages.${pkgs.system}.default
  ];
}
