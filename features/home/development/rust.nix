{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.development.rust;
in {
  options.features.development.rust.enable = mkEnableOption "Enable rust";

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
