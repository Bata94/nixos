{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.development.android;
in {
  options.features.home.development.android.enable = mkEnableOption "Enable Android";

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        # Android
        android-tools
        # android-udev-rules
        android-studio
        google-chrome
      ];
      sessionVariables = rec {
        ANDROID_HOME = "${config.home.homeDirectory}/Android/Sdk";
        ANDROID_SDK_ROOT = ANDROID_HOME + "/platform-tools/adb";
        PATH = "$PATH:" + ANDROID_HOME + "/emulator:" + ANDROID_HOME + "/platform-tools:";

        CHROME_EXECUTABLE = "${config.home.homeDirectory}/.nix-profile/bin/google-chrome-stable";
      };
    };
  };
}
