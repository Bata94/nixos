{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.cli.tui.filebrowser.ranger;
in {
  options.features.home.cli.tui.filebrowser.ranger.enable = mkEnableOption "Enable ranger";

  config = mkIf cfg.enable {
    programs.ranger = {
      enable = true;
    };
  };
}
