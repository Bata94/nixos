{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.wm.hyprland;
in {
  options.features.home.wm.hyprland.enable = mkEnableOption "Enable Hyprland";

  config = mkIf cfg.enable {};
}
