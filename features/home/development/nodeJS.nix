{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.development.nodeJS;
in {
  options.features.home.development.nodeJS.enable = mkEnableOption "Enable nodeJS";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs_24
      watchman # wangle throws error...
      prettierd
      eslint_d

      eas-cli
    ];
  };
}
