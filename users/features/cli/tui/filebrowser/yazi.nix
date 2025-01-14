{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.tui.filebrowser.yazi;
in {
  options.features.cli.tui.filebrowser.yazi.enable = mkEnableOption "Enable yazi";

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
    };
  };
}
