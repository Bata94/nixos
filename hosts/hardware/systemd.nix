{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.hardware.systemd;
in {
  options.hardware.systemd.enable = mkEnableOption "Enable systemd tweaks";

  config = mkIf cfg.enable {
    services.journald.extraConfig = "SystemMaxUse=50M\nSystemMaxFiles=5";
    services.journald.rateLimitBurst = 500;
    services.journald.rateLimitInterval = "30s";
  };
}
