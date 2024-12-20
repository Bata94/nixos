{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.development.android;
in {
  options.features.development.android.enable = mkEnableOption "Enable Android";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Android
      android-tools
      android-udev-rules
      android-studio
      google-chrome
    ];
  };
}
