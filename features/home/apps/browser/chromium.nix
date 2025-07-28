{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.apps.browser.chromium;
in {
  options.features.home.apps.browser.chromium.enable = mkEnableOption "Enable chromium";

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
    };
  };
}
