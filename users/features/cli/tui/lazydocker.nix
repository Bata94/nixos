{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.filebrowser.lazydocker;
in {
  options.features.cli.filebrowser.lazydocker.enable = mkEnableOption "Enable lazydocker";

  config = mkIf cfg.enable {
    programs.lazydocker = {
      enable = true;
    };
  };
}
