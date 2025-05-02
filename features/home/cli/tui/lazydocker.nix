{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.cli.tui.lazydocker;
in {
  options.features.home.cli.tui.lazydocker.enable = mkEnableOption "Enable lazydocker";

  config = mkIf cfg.enable {
    # TODO: Not defined
    # programs.lazydocker = {
    #   enable = true;
    # };
  };
}
