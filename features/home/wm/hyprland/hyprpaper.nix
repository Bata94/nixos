{
  config,
  hostName,
  pkgs,
  lib,
  ...
}: let
  # TODO: Add a default Wallpaper
  sourceAssetsDir = builtins.path {
    path = ../../../../assets/wallpapers/${hostName};
  };
  destinationWallpapersDir = "${config.xdg.configHome}/hypr/wallpapers";

  getBackgroundImages = path: let
    dirContents = builtins.readDir path;
    imageExtensions = [
      "jpg"
      "jpeg"
      "png"
      "gif"
      "bmp"
      "webp"
    ];
    isImageFile = fileName: let
      extension = lib.lists.last (lib.strings.splitString "." fileName);
    in
      lib.lists.elem extension imageExtensions;
  in
    lib.attrsets.filterAttrs (name: type: type == "regular" && isImageFile name) dirContents // {};

  sourceBackgroundFiles = lib.attrsets.attrNames (getBackgroundImages sourceAssetsDir);

  wallpaperSymlinks = lib.attrsets.listToAttrs (
    lib.lists.map (fileName: {
      name = "${destinationWallpapersDir}/${fileName}";
      value = {
        source = "${sourceAssetsDir}/${fileName}";
      };
    })
    sourceBackgroundFiles
  );

  hyprpaperPreloadPaths =
    lib.lists.map (
      fileName: "${destinationWallpapersDir}/${fileName}"
    )
    sourceBackgroundFiles;

  initialWallpaper =
    if lib.lists.length hyprpaperPreloadPaths > 0
    then [",${lib.lists.head hyprpaperPreloadPaths}"]
    else [];
in {
  xdg.configHome = lib.mkDefault "${config.home.homeDirectory}/.config";

  home.file = lib.optionalAttrs (lib.lists.length sourceBackgroundFiles > 0) wallpaperSymlinks;

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;

      wallpaper = {
        monitor = "";
        path = destinationWallpapersDir;
      };

      # preload =
      #   if lib.lists.length hyprpaperPreloadPaths > 0
      #   then hyprpaperPreloadPaths
      #   else [];
      # # TODO: Make it random and changeable vie hotkey
      # wallpaper = initialWallpaper;
    };
  };
}
