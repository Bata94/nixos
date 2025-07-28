{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.apps.nextcloud-client;
in {
  options.features.home.apps.nextcloud-client.enable = mkEnableOption "Enable Nextcloud-Client";

  config = mkIf cfg.enable {
    services.nextcloud-client = {
      enable = true;
      startInBackground = true;
    };
  };
}
