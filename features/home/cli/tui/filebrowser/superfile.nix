{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.cli.tui.filebrowser.superfile;
in {
  options.features.home.cli.tui.filebrowser.superfile.enable = mkEnableOption "Enable superfile";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      superfile
    ];
  };
}
