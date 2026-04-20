{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.home.wm.hyprland;
in {
  config = mkIf cfg.enable {
    # home.file.".config/quickshell/shell.qml".text = ''
    # '';
    home.packages = with pkgs;
      [
        ## Deps via quickshell (caelestia-shell)
        ddcutil
        # brightnessctl
        app2unit
        cava
        networkmanager
        lm_sensors
        fish
        aubio
        libgcc
        # grim
        swappy
        # wl-clipboard
        libqalculate
        inotify-tools
        bluez
        coreutils
        findutils
        file
        makeWrapper
        ## Caelestia-cli
        # swappy
        libnotify
        # slurp
        # wl-clipboard
        # cliphist
        # app2unit
        dart-sass
        # grim
        fuzzel
        wl-screenrec
        dconf
        # killall
        ## Div
        imagemagick
        material-symbols
        nerd-fonts.jetbrains-mono
      ]
      ++ [
        pkgs.kdePackages.qtsvg
        pkgs.kdePackages.qtimageformats
        pkgs.kdePackages.qtmultimedia
        pkgs.kdePackages.qt5compat
        pkgs.kdePackages.qtdeclarative
        pkgs.kdePackages.qt6ct

        pkgs.kdePackages.kiconthemes
        pkgs.kdePackages.breeze-icons
      ]
      ++ [
        python3.pkgs.hatch-vcs
        python3.pkgs.hatchling
        python3.pkgs.materialyoucolor
        python3.pkgs.pillow
        python3.pkgs.aubio
        python3.pkgs.pyaudio
        python3.pkgs.numpy
      ]
      ++ [
        inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
  };
}
