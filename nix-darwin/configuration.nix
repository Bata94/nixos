{
  pkgs,
  lib,
  nixvim,
  ...
}: {
  # Nix configuration ------------------------------------------------------------------------------

  users = {
    users = {
      bata = {
        shell = pkgs.zsh;
        description = "Bastian Sievers";
        home = "/Users/bata";
      };
    };
  };

  # nix.binaryCaches = [
  #   "https://cache.nixos.org/"
  # ];
  # nix.binaryCachePublicKeys = [
  #   "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  # ];
  nix.settings.trusted-users = [
    "bata"
    # "@admin"
  ];
  nix.configureBuildUsers = true;

  # Enable experimental nix command and flakes
  # nix.package = pkgs.nixUnstable;
  nix.extraOptions =
    ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    ''
    + lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = [
    pkgs.alacritty
    pkgs.yabai
    pkgs.android-tools
    # pkgs.terminal-notifier
    pkgs.jdk20
    nixvim.packages.aarch64-darwin.default
  ];

  # https://github.com/nix-community/home-manager/issues/423
  # environment.variables = {
  # TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
  # };
  programs.nix-index.enable = true;

  homebrew = {
    enable = true;
    # onActivation.cleanup = "uninstall";

    taps = [];
    brews = ["nvm"];
    casks = [];
  };

  # Fonts
  fonts.packages = with pkgs; [
    corefonts
    cm_unicode

    font-awesome
    powerline-fonts
    powerline-symbols

    ubuntu_font_family
    source-code-pro
    jetbrains-mono
    twemoji-color-font
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    # emojione
    # kanji-stroke-order-font
    # ipafont

    (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly" "Inconsolata" "JetBrainsMono" "Iosevka" "FiraCode"];})
  ];
  # fonts.enableFontDir = true;
  # fonts.fonts = with pkgs; [
  #    recursive
  #    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  #  ];

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  # Tmp fix for Rosetta
  system.activationScripts.extraActivation.text = ''
    softwareupdate --install-rosetta --agree-to-license
  '';

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;
}
