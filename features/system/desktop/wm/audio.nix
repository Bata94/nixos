{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.wm.audio;
in {
  options.features.desktop.wm.audio.enable = mkEnableOption "Enable Audio";

  config = mkIf cfg.enable {
    # Remove sound.enable or set it to false if you had it set previously, as sound.enable is only meant for ALSA-based configurations
    # sound.enable = false;

    # rtkit is optional but recommended
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      audio.enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      # If you want to use JACK applications, uncomment this
      jack.enable = true;

      wireplumber = {
        enable = true;
        configPackages = [];
      };

      extraConfig = {
        pipewire = {
          "92-low-latency" = {
            "context.properties" = {
              "default.clock.rate" = 44100;
              "default.clock.quantum" = 256;
              "default.clock.min-quantum" = 32;
              "default.clock.max-quantum" = 2048;
            };
          };
        };
      };
    };
  };
}
