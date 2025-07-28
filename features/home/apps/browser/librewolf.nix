{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.apps.browser.librewolf;
in {
  options.features.home.apps.browser.librewolf.enable = mkEnableOption "Enable librewolf";

  config = mkIf cfg.enable {
    programs.librewolf = {
      enable = true;
    };
  };
}
