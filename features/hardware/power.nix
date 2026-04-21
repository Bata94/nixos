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
      # thermald.enable = true;
      upower.enable = true;
      # power-profiles-daemon.enable = true;
      auto-cpufreq = {
        enable = true;
        settings = {
          battery = {
            governor = "powersave";
            turbo = "never";
          };
          charger = {
            governor = "schedutil";
            turbo = "auto";
          };
        };
      };
    };

    services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_SCALING_GOVERNOR_ON_AC = "schedutil";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        PLATFORM_PROFILE_ON_BAT = "quiet";
        PLATFORM_PROFILE_ON_AC = "balanced"; # "performance";

        CPU_BOOST_ON_BAT = 0;
        CPU_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 0;
        CPU_HWP_DYN_BOOST_ON_AC = 1;

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 35;

        NMI_WATCHDOG = 0;

        #Optional helps save long term battery health
        # START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
        # STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
      };
    };

    powerManagement = {
      enable = true;
      powertop.enable = true;
      cpuFreqGovernor = "schedutil";
    };

    boot = {
      kernelModules = ["acpi_call" "ec_sys"];
      extraModulePackages = with config.boot.kernelPackages; [
        acpi_call
      ];
    };
  };
}
