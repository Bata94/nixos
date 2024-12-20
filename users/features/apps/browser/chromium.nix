{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.apps.browser.chromium;
in {
  options.features.apps.browser.chromium.enable = mkEnableOption "Enable chromium";

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
    };
  };
}
