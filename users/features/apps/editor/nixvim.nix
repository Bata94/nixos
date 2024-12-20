{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.apps.editor.nixvim;
in {
  options.features.apps.editor.nixvim.enable = mkEnableOption "Enable nixvim";

  config = mkIf cfg.enable {
    home.packages = [inputs.nixvim.packages.${pkgs.system}.default];
  };
}
