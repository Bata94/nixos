{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.desktop.services.gaming;
in {
  options.features.desktop.services.gaming.enable = mkEnableOption "Enable Gaming";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      steam
      heroic
      (lutris.override {
        extraPkgs = pkgs: [
          # List package dependencies here
        ];
      })
    ];
    programs.gamemode.enable = true;
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      gamescopeSession.enable = true;
    };
  };
}
