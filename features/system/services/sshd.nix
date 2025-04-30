{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.services.sshd;
in {
  options.features.desktop.services.sshd.enable = mkEnableOption "Enable SSHD";

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
