{
  inputs,
  home-manager-darwin,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  # imports = [
  #   home-manager-darwin.darwinModules.home-manager
  # ];

  users.users.bata = {
    name = "bata";
    home = "/Users/bata";
  };
  home-manager.users.bata = {
    home.stateVersion = "24.11";
    imports=[./home.nix];
  };

  system = {
    stateVersion = 5;
    # configurationRevision = self.rev or self.dirtyRev or null;
  };

  environment.shellInit = ''
    ulimit -n 2048
  '';

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
    brewPrefix = "/opt/homebrew/bin";
    caskArgs = {
      no_quarantine = true;
    };
    casks = [
      "stats"
      "ghostty"
      "google-chrome"
      "zen-browser"
    ];
    brews = [];
  };
  environment.systemPackages = with pkgs; [
    # TODO:
    # inputs.agenix.packages."${system}".default

    lazygit

    wget
    rsync
    just
    ripgrep
    google-cloud-sdk
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  nix = {
    enable = true;
    settings = {
      experimental-features = "nix-command flakes";
      max-jobs = "auto";
      trusted-users = [
        "root"
        "notthebee"
        "@admin"
      ];
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  environment.launchDaemons."limit.maxfiles.plist" = {
    enable = true;
    text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
      "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
      <key>Label</key>
      <string>limit.maxfiles</string>
      <key>ProgramArguments</key>
      <array>
      <string>launchctl</string>
      <string>limit</string>
      <string>maxfiles</string>
      <string>524288</string>
      <string>524288</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>ServiceIPC</key>
      <false/>
      </dict>
      </plist>
    '';
  };
  system = {
    defaults = {
      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
      finder = {
        FXDefaultSearchScope = "SCcf";
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        ShowStatusBar = true;
      };
      dock = {
        # Quick Note on the bottom right hot corner
        wvous-br-corner = 14;
        tilesize = 50;
      };
      NSGlobalDomain = {
        "com.apple.sound.beep.volume" = 0.0;
        InitialKeyRepeat = 13;
        KeyRepeat = 2;
      };
    };
    # TODO: Error: No Privelages
    # activationScripts.postUserActivation.text = ''
    #   # Following line should allow us to avoid a logout/login cycle
    #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    #   launchctl stop com.apple.Dock.agent
    #   launchctl start com.apple.Dock.agent
    # '';
  };
}
