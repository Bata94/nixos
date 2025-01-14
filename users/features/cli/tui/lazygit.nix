{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.tui.lazygit;
in {
  options.features.cli.tui.lazygit.enable = mkEnableOption "Enable lazygit";

  config = mkIf cfg.enable {
    programs.lazygit = {
      enable = true;
    };
  };
}
