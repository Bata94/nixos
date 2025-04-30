{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.development.java;
in {
  options.features.development.java.enable = mkEnableOption "Enable Java";

  config = mkIf cfg.enable {
    programs.java = {
      enable = true;
    };
  };
}
