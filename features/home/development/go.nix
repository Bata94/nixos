{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.development.go;
in {
  options.features.home.development.go.enable = mkEnableOption "Enable Go";

  config = mkIf cfg.enable {
    home = {
      # TODO: Prob add more Pkgs
      packages = with pkgs; [
        go
        gopls
        golangci-lint
        gofumpt
        gotools
      ];
      # TODO: Don't know if needed
      # sessionVariables = {
      #   PATH = "$PATH:" + "${config.home.homeDirectory}/go/bin/";
      # };
    };
  };
}
