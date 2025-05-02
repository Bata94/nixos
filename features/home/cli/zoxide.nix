{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.cli.zoxide;
in {
  options.features.home.cli.zoxide.enable = mkEnableOption "Enable zoxide";
  config = mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
  };
}
