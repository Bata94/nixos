{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.system.desktop.wm.defaultFonts;
in {
  options.features.system.desktop.wm.defaultFonts.enable = mkEnableOption "Use default fonts";

  config = mkIf cfg.enable {
    ## From old XPS
    # fontDir.enable = true;
    # enableDefaultPackages = true;
    # fontconfig = {
    #   defaultFonts = {
    #     monospace = ["FiraCode Nerd Font Mono"];
    #     sansSerif = ["FiraCode Nerd Font"];
    #     serif = ["FiraCode Nerd Font"];
    #   };
    # };

    fonts = {
      packages = with pkgs; [
        corefonts
        cm_unicode

        font-awesome
        powerline-fonts
        powerline-symbols
        material-symbols

        ubuntu_font_family
        source-code-pro
        jetbrains-mono
        twemoji-color-font
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        # emojione
        kanji-stroke-order-font
        ipafont

        nerd-fonts.symbols-only
        nerd-fonts.noto
        nerd-fonts.fira-code
        nerd-fonts.inconsolata
        nerd-fonts.jetbrains-mono
        nerd-fonts.fira-code
        nerd-fonts.iosevka
      ];
    };
  };
}
