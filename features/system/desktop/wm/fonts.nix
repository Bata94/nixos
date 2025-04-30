{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.wm.defaultFonts;
in {
  options.features.desktop.wm.defaultFonts.enable = mkEnableOption "Use default fonts";

  config = mkIf cfg.enable {
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
}
