{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.development.go;
in {
  options.features.development.go.enable = mkEnableOption "Enable Go";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      go
      gopls
      golangci-lint
      gofumpt
      gotools
    ];
  };
}
