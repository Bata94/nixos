{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.apps.browser.tor;
in {
  options.features.apps.browser.tor.enable = mkEnableOption "Enable tor";

  config = mkIf cfg.enable {
    # TODO: Setup Tor
  };
}
