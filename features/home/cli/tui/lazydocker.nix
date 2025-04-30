{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.tui.lazydocker;
in {
  options.features.cli.tui.lazydocker.enable = mkEnableOption "Enable lazydocker";

  config = mkIf cfg.enable {
    # TODO: Not defined
    # programs.lazydocker = {
    #   enable = true;
    # };
  };
}
