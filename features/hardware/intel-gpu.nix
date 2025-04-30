{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.hardware.intel-gpu;
in {
  options.hardware.intel-gpu.enable = mkEnableOption "Enable intel-gpu";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      intel-gpu-tools
      intel-media-driver
      vaapiIntel
    ];
  };
}
