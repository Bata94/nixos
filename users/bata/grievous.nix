{ pkgs, inputs, ... }:
{
  imports = [
    ./home.nix

    ../common
    ../../features/home

    inputs.zen-browser.homeModules.twilight
    inputs.nix-colors.homeManagerModules.default
  ];

  colorScheme = inputs.nix-colors.colorSchemes.rose-pine;

  home.packages = with pkgs; [
    brightnessctl
    spotify-player
  ];

  programs.zen-browser = {
    enable = true;
    nativeMessagingHosts = [pkgs.firefoxpwa];
    policies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true; # save webs for later reading
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
    };
  };

  features.home = {
    apps = {
      editor.nixvim.enable = true;
      terminal.ghostty.enable = true;
    };
    cli = {
      tui = {
        filebrowser.yazi.enable = true;
        lazygit.enable = true;
        lazydocker.enable = false;
      };
      git.enable = true;
      sh.enable = true;
      zoxide.enable = true;
    };
    # development = {};
    wm = {
      dunst.enable = false;
      hyprland = {
        enable = true;
        virtKeyboard = true;
      };
    };
  };
}
