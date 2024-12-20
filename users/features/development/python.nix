{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.development.python;
in {
  options.features.development.python.enable = mkEnableOption "Enable python";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      python3Full
      pipx
      imath
      pystring
      pyenv
      mypy
      ruff
      black
      isort
    ];
  };
}
