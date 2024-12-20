{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.wm.dunst;
in {
  options.features.wm.dunst.enable = mkEnableOption "Enable Dunst";

  config = mkIf cfg.enable {};
}
