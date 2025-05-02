{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.system.services.sshd;
in {
  options.features.system.services.sshd.enable = mkEnableOption "Enable SSHD";

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
}
