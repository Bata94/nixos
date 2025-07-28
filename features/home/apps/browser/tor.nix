{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.apps.browser.tor;
in {
  options.features.home.apps.browser.tor.enable = mkEnableOption "Enable tor";

  config = mkIf cfg.enable {
    # TODO: Setup Tor
  };
}
