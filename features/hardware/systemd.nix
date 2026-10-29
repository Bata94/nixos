{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.hardware.systemd;
in {
  options.features.hardware.systemd.enable = mkEnableOption "Enable systemd tweaks";

  config = mkIf cfg.enable {
    services.journald.settings.Journal.extraConfig = "SystemMaxUse=50M\nSystemMaxFiles=5";
    services.journald.settings.Journal.rateLimitBurst = 500;
    services.journald.settings.Journal.rateLimitInterval = "30s";
  };
}
