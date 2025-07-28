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
      nodejs_20
      watchman
      prettierd
      eslint_d

      nodePackages.eas-cli
    ];
  };
}
