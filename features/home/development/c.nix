{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.development.c;
in {
  options.features.home.development.c.enable = mkEnableOption "Enable C";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gcc
      gnumake
      cmake
      autoconf
      automake
      libtool
    ];
  };
}
