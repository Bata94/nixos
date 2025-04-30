{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.services.ollama;
in {
  options.features.desktop.services.ollama.enable = mkEnableOption "Enable ollama";

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.oterm];
    services.ollama = {
      enable = true;
      acceleration = "cuda";
    };
  };
}
