{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.cli.tui.lazygit;
in {
  options.features.home.cli.tui.lazygit.enable = mkEnableOption "Enable lazygit";

  config = mkIf cfg.enable {
    programs.lazygit = {
      enable = true;
    };
  };
}
