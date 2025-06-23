{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.cli.tui.filebrowser.yazi;
in {
  options.features.home.cli.tui.filebrowser.yazi.enable = mkEnableOption "Enable yazi";

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
    };
  };
}
