{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.wm.hyprland;
in {
  options.features.wm.hyprland.enable = mkEnableOption "Enable Hyprland";

  config = mkIf cfg.enable {};
}
