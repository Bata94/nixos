{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.filebrowser.lazygit;
in {
  options.features.cli.filebrowser.lazygit.enable = mkEnableOption "Enable lazygit";

  config = mkIf cfg.enable {
    programs.lazygit = {
      enable = true;
    };
  };
}
