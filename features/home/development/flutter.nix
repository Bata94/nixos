{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.development.flutter;
in {
  options.features.home.development.flutter.enable = mkEnableOption "Enable Flutter";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      flutter
    ];
  };
}
