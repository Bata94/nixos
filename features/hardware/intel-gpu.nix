{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.hardware.intel-gpu;
in {
  options.features.hardware.intel-gpu.enable = mkEnableOption "Enable intel-gpu";

  config = mkIf cfg.enable {
    hardware.intel-gpu-tools.enable = true;

    environment.systemPackages = with pkgs; [
      intel-gpu-tools
      intel-media-driver
      intel-vaapi-driver
    ];
  };
}
