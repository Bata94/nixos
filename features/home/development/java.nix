{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.development.java;
in {
  options.features.home.development.java.enable = mkEnableOption "Enable Java";

  config = mkIf cfg.enable {
    programs.java = {
      enable = true;
    };
  };
}
