{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.hardware.time;
in {
  options.hardware.time.enable = mkEnableOption "Enable time service";

  config = mkIf cfg.enable {
    services.timesyncd.enable = true;
  };
}
