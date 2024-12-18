{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.hardware.printing;
in {
  options.hardware.printing.enable = mkEnableOption "Enable printing";

  config = mkIf cfg.enable {
    services.printing.enable = true;
    services.avahi.enable = true;
    services.avahi.nssmdns4 = true;
    services.avahi.openFirewall = true;
    environment.systemPackages = [pkgs.cups-filters];
  };
}
