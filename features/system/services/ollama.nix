{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.system.services.ollama;
in {
  options.features.system.services.ollama.enable = mkEnableOption "Enable ollama";

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.oterm];
    services.ollama = {
      enable = true;
      acceleration = "cuda";
    };
  };
}
