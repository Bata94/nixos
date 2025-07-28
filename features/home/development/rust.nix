{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.home.development.rust;
in {
  options.features.home.development.rust.enable = mkEnableOption "Enable rust";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      rustup
      # rustc
      # carrust
      # rustfmt
      # rust-analyzer
      # clippy
    ];
  };
}
