{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.hardware.power;
in {
  options.features.hardware.power.enable = mkEnableOption "Enable power settings";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      acpi
      powertop

      dmidecode

      lm_sensors
      brightnessctl
    ];

    services = {
      thermald.enable = true;
      upower.enable = true;
      power-profiles-daemon.enable = true;
    };

    powerManagement = {
      enable = true;
      powertop.enable = true;
    };

    boot = {
      kernelModules = ["acpi_call" "ec_sys"];
      extraModulePackages = with config.boot.kernelPackages; [
        acpi_call
      ];
    };
  };
}
