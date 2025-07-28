{
  inputs,
  pkgs,
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

  home.packages = with pkgs; [
    brightnessctl
    spotify-player

    ## From old Config, need to be adjusted
    alejandra

    prismlauncher

    # kubectl
    # kubernetes-helm

    # parsec-bin
    moonlight-qt
    # remmina

    # turso-cli
    atlas # Ent DB Schemas Integration
    # brave
    html-tidy
    # obsidian
    postgresql
    just
    gemini-cli

    discord
    vesktop # Discord APP
    # whatsapp-for-linux
    # telegram-desktop
    teams-for-linux
    webcamoid

    # rustdesk-flutter
    lan-mouse

    ulauncher
    libsForQt5.kcolorpicker

    onlyoffice-bin
    # texliveFull

    easyeffects
    movit
    mediainfo
    libmediainfo
    mediainfo-gui
    audio-recorder
    # vlc
    # mpv
    # feh
    kdePackages.okular
    # spotify
    spotify-player # Spotify TUI App
    pavucontrol
    # obs-studio
    # zathura # PDF Reader

    # godot_4
    # dbeaver-bin
    # mysql-workbench
    sysbench
    insomnia
    # tor-browser
    # qutebrowser
    # anydesk
    # partition-manager
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
      browser = {
        chromium.enable = true;
      };
      editor.nixvim.enable = true;
      terminal.ghostty.enable = true;
      nextcloud-client.enable = true;
    };
    cli = {
      tui = {
        filebrowser = {
          yazi.enable = true;
          superfile.enable = true;
        };
        lazygit.enable = true;
        lazydocker.enable = true;
      };
      git.enable = true;
      sh.enable = true;
      zoxide.enable = true;
    };
    development = {
      android.enable = true;
      c.enable = true;
      flutter.enable = true;
      go.enable = true;
      java.enable = true;
      lua.enable = true;
      nodeJS.enable = true;
      python.enable = true;
      rust.enable = false;
    };
    wm = {
      dunst.enable = false;
      hyprland = {
        enable = true;
        virtKeyboard = false;
        nvidia_envs = true;
        exec-once-services = ["easyeffects --gapplication-service"];
        exec-once-apps = [];
      };
    };
  };
}
