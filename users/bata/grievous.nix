{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./home.nix

    ../common
    ../../features/home

    inputs.sops-nix.homeManagerModules.sops

    inputs.zen-browser.homeModules.twilight
    inputs.nix-colors.homeManagerModules.default
  ];

  colorScheme = inputs.nix-colors.colorSchemes.rose-pine;

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    validateSopsFiles = false;

    age.keyFile = "/home/bata/.config/sops/age/keys.txt";

    secrets = {
      bata_ssh_key = {
        path = "/home/bata/.ssh/id_bata_master";
      };
      "software_pw/google" = {};
      "software_pw/github" = {};
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

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
      browser.chromium.enable = true;
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
        tablet = true;
        virtKeyboard = true;
      };
    };
  };
}
