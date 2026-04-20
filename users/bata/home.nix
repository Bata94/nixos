{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.home-manager = {
    enable = true;
  };

  home = {
    username = lib.mkDefault "bata";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = "26.05";
  };

  home.packages = with pkgs;
    [
      feh
      mpv
    ]
    ++ [
      kdePackages.okular
    ];

  # TODO: rethink/move for server users
  home.sessionVariables = {
    EDITOR = "nvim";
    SPAWNEDITOR = "exec ghostty -e nvim";
    TERM = "ghostty";
    BROWSER = "zen";

    # TODO: move to lang specific modules
    # ANDROID_HOME = "${config.home.homeDirectory}/Android/Sdk";
    # ANDROID_SDK_ROOT = ANDROID_HOME + "/platform-tools/adb";
    # PATH = "$PATH:" + ANDROID_HOME + "/emulator:" + ANDROID_HOME + "/platform-tools:" + "${config.home.homeDirectory}/go/bin/";
    # CHROME_EXECUTABLE = "${config.home.homeDirectory}/.nix-profile/bin/google-chrome-stable";
  };

  # TODO: mk more specific dirs like Projects etc...
  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    music = null;
    videos = null;
    pictures = null;
    templates = null;
    download = "${config.home.homeDirectory}/Downloads";
    documents = null;
    desktop = null;
    publicShare = null;
  };
  xdg.mime.enable = true;
  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/pdf" = ["okular.desktop"];
      "image/*" = ["feh.desktop"];
      "video/*" = ["mpv.desktop"];
      "video/png" = ["mpv.desktop"];
      "video/jpg" = ["mpv.desktop"];

      "application/x-extension-shtml" = ["zen.desktop"];
      "application/x-extension-xhtml" = ["zen.desktop"];
      "application/x-extension-html" = ["zen.desktop"];
      "application/x-extension-xht" = ["zen.desktop"];
      "application/x-extension-htm" = ["zen.desktop"];
      "x-scheme-handler/unknown" = ["zen.desktop"];
      "x-scheme-handler/mailto" = ["zen.desktop"];
      "x-scheme-handler/chrome" = ["zen.desktop"];
      "x-scheme-handler/about" = ["zen.desktop"];
      "x-scheme-handler/https" = ["zen.desktop"];
      "x-scheme-handler/http" = ["zen.desktop"];
      "application/xhtml+xml" = ["zen.desktop"];
      "application/json" = ["zen.desktop"];
      "text/plain" = ["zen.desktop"];
      "text/html" = ["zen.desktop"];
    };
    defaultApplications = {
      "application/pdf" = ["okular.desktop"];
      "image/*" = ["feh.desktop"];
      "video/*" = ["mpv.desktop"];
      "video/png" = ["mpv.desktop"];
      "video/jpg" = ["mpv.desktop"];

      "application/x-extension-shtml" = ["zen.desktop"];
      "application/x-extension-xhtml" = ["zen.desktop"];
      "application/x-extension-html" = ["zen.desktop"];
      "application/x-extension-xht" = ["zen.desktop"];
      "application/x-extension-htm" = ["zen.desktop"];
      "x-scheme-handler/unknown" = ["zen.desktop"];
      "x-scheme-handler/mailto" = ["zen.desktop"];
      "x-scheme-handler/chrome" = ["zen.desktop"];
      "x-scheme-handler/about" = ["zen.desktop"];
      "x-scheme-handler/https" = ["zen.desktop"];
      "x-scheme-handler/http" = ["zen.desktop"];
      "application/xhtml+xml" = ["zen.desktop"];
      "application/json" = ["zen.desktop"];
      "text/plain" = ["zen.desktop"];
      "text/html" = ["zen.desktop"];
    };
  };
}
