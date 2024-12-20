{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.apps.browser.brave;
in {
  options.features.apps.browser.brave.enable = mkEnableOption "Enable brave";

  config = mkIf cfg.enable {
    # TODO: Setup Brave
  };
}
