{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.development.lua;
in {
  options.features.development.lua.enable = mkEnableOption "Enable lua";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lua
      stylua
    ];
  };
}
