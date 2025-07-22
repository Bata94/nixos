{ inputs, config, lib, pkgs, ... }:
with lib; let
  cfg = config.features.home.wm.hyprland;
in {
  config = mkIf cfg.enable {
    # home.file.".config/quickshell/shell.qml".text = ''
    # '';
    home.packages = with pkgs.kdePackages; [
      qtsvg
      qtimageformats
      qtmultimedia
      qt5compat

      kiconthemes
      breeze-icons
    ] ++ [ inputs.quickshell.packages.${pkgs.system}.default ];
  };
}
