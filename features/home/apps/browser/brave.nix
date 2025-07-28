{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.apps.browser.brave;
in {
  options.features.home.apps.browser.brave.enable = mkEnableOption "Enable brave";

  config = mkIf cfg.enable {
    # TODO: Setup Brave
  };
}
