{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./disko-configuration.nix
    ./hardware-configuration.nix

    ../../../features/hardware
    ../../../features/system

    inputs.sops-nix.nixosModules.sops
  ];
  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    validateSopsFiles = false;

    age = {
      # automatically import host SSH keys as age keys and generate if needed
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    secrets = {
      bata_pw = {
        neededForUsers = true;
      };
    };
  };

  # nix.package = pkgs.nixVersions.stable;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/vda";

  # programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = [];

  # make the tailscale command usable to users
  # environment.systemPackages = [pkgs.tailscale];
  # enable the tailscale service
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    authKeyFile = "/run/secrets/tailscale_key";
    extraUpFlags = [
      "--advertise-exit-node"
      "--ssh"
    ];
  };

  # create a oneshot job to authenticate to Tailscale
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = ["network-pre.target" "tailscale.service"];
    wants = ["network-pre.target" "tailscale.service"];
    wantedBy = ["multi-user.target"];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up --login-server=https://hs.sievers.ruhr --accept-dns --accept-routes
    '';
  };

  features = {
    hardware = {
      time.enable = true;
      systemd.enable = true;
    };
    system = {
      services = {
        docker.enable = true;
        sshd.enable = true;
      };
    };
  };

  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "lz4";
    memoryPercent = 50;
  };

  networking = {
    hostName = "bespin";
    firewall = {
      enable = true;
      allowedTCPPorts = [22 80 443];
      allowedUDPPorts = [80 443 3478];
    };
  };

  system.stateVersion = "26.05";
}
