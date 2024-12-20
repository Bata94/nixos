{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.development.flutter;
in {
  options.features.development.flutter.enable = mkEnableOption "Enable Flutter";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      flutter
    ];
  };
}
