{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.features.hardware.time;
in
{
  options.features.hardware.time.enable = mkEnableOption "Enable time service";

  config = mkIf cfg.enable {
    services.timesyncd = {
      enable = true;
      servers = [
        "0.de.pool.ntp.org"
        "1.de.pool.ntp.org"
        "2.de.pool.ntp.org"
        "3.de.pool.ntp.org"
      ];
    };
  };
}
