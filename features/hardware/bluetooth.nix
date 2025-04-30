{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.hardware.bluetooth;
in {
  options.hardware.bluetooth.enable = mkEnableOption "Enable bluetooth";

  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
