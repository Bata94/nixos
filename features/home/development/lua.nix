{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.development.lua;
in {
  options.features.home.development.lua.enable = mkEnableOption "Enable lua";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lua
      stylua
    ];
  };
}
