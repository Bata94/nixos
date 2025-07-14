{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.features.home.wm.hyprland;
in {
  config = mkIf cfg.enable {
    # home.file.".config/hypr/hypridle.conf".text = ''
    # '';
    home.packages = with pkgs; [ quickshell ];
  };
}
