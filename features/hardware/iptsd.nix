{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.hardware.iptsd;
in {
  options.features.hardware.iptsd.enable = mkEnableOption "Enable Intel Touchscreen Driver";

  config = mkIf cfg.enable {
    services = {
      iptsd = {
        enable = true;
        config = {
          Touchscreen = {
            DisableOnPalm = true;
            DisableOnStylus = true;
          };
        };
      };
    };
  };
}
