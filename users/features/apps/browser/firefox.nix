{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.apps.browser.firefox;
in {
  options.features.apps.browser.firefox.enable = mkEnableOption "Enable firefox";

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles = {
        default = {
          id = 0;
          name = "default";
          isDefault = true;
          extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
            # bitwarden
            # ublock-origin
            sponsorblock
            darkreader
            # vimium
            # multi-account-containers
            youtube-shorts-block

            # Catppuccin
          ];

          search.engines = {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@n"];
            };
          };

          search = {
            force = true;
            default = "Google";
            order = ["Google"];
          };

          settings = {
            "general.smoothScroll" = true;

            "browser.disableResetPrompt" = true;
            "browser.download.panel.shown" = true;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "browser.shell.checkDefaultBrowser" = false;
            "browser.shell.defaultBrowserCheckCount" = 1;
            "browser.startup.homepage" = "https://home.sits.ruhr/";
            "browser.search.defaultenginename" = "Google";
            "browser.aboutConfig.showWarning" = false;
            "browser.compactmode.show" = true;

            "widget.use-xdg-desktop-portal.file-picker" = 1;

            "intl.accept_languages" = "de, de-DE, en-US, en";

            "media.hardware-video-decoding.enabled" = false;
            "media.hardware-video-decoding.force-enabled" = false;

            "dom.security.https_only_mode" = true;

            "identity.fxaccounts.enabled" = false;

            "privacy.trackingprotection.enabled" = true;

            "signon.rememberSignons" = false;
          };
        };
      };
    };
  };
}
