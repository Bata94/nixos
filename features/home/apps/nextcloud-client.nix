{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.apps.nextcloud-client;
in {
  options.features.apps.nextcloud-client.enable = mkEnableOption "Enable Nextcloud-Client";

  config = mkIf cfg.enable {
    services.nextcloud-client = {
      enable = true;
      startInBackground = true;
    };
  };
}
