{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.filebrowser.yazi;
in {
  options.features.cli.filebrowser.yazi.enable = mkEnableOption "Enable yazi";

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
    };
  };
}
