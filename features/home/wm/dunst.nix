{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.wm.dunst;
in {
  options.features.home.wm.dunst.enable = mkEnableOption "Enable Dunst";

  config = mkIf cfg.enable {};
}
