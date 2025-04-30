{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.apps.browser.librewolf;
in {
  options.features.apps.browser.librewolf.enable = mkEnableOption "Enable librewolf";

  config = mkIf cfg.enable {
    programs.librewolf = {
      enable = true;
    };
  };
}
