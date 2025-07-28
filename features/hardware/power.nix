{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.features.hardware.power;
in
{
  options.features.hardware.power.enable = mkEnableOption "Enable power settings";

  config = mkIf cfg.enable {
    services = {
      thermald.enable = true;
      upower.enable = true;
      power-profiles-daemon.enable = true;
    };

    powerManagement = {
      enable = true;
      powertop.enable = true;
    };
  };
}
