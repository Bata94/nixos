{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.filebrowser.ranger;
in {
  options.features.cli.filebrowser.ranger.enable = mkEnableOption "Enable ranger";

  config = mkIf cfg.enable {
    programs.ranger = {
      enable = true;
    };
  };
}
