{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.development.c;
in {
  options.features.development.c.enable = mkEnableOption "Enable C";

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
