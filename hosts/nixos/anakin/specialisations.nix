# Specializations for anakin (Dell XPS 17 9710)
# Provides a "no-nvidia" specialization to completely disable the NVIDIA dGPU for power saving
{
  config,
  lib,
  pkgs,
  ...
}: {
  specialisation.no-nvidia.configuration = {
    system.nixos.tags = ["no-nvidia"];

    # Disable NVIDIA GPU completely by disabling the feature module
    features.hardware.nvidia-gpu.enable = lib.mkForce false;

    # Enable Intel GPU tools and support
    features.hardware.intel-gpu.enable = true;

    # Use only the Intel driver for X/Wayland (no nvidia)
    services.xserver.videoDrivers = lib.mkOverride 50 ["modesetting"];

    # Blacklist NVIDIA kernel modules so they don't load
    boot.blacklistedKernelModules = [
      "nvidia"
      "nvidia_uvm"
      "nvidia_drm"
      "nvidia_modeset"
    ];

    # Note: Removed pci=noacpi as it breaks keyboard/trackpad ACPI interrupts

    # Power down NVIDIA GPU via PCIe runtime PM after boot
    # This turns off the dGPU completely when not in use
    systemd.services.disable-nvidia = {
      description = "Disable NVIDIA GPU for power saving";
      after = ["multi-user.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "disable-nvidia" ''
          # Turn off NVIDIA GPU via PCI power control
          if [ -d /sys/bus/pci/devices/0000:01:00.0 ]; then
            echo "Disabling NVIDIA GPU..."
            # Remove the driver if loaded
            if [ -e /sys/bus/pci/devices/0000:01:00.0/driver ]; then
              echo 0000:01:00.0 > /sys/bus/pci/devices/0000:01:00.0/driver/unbind 2>/dev/null || true
            fi
            # Enable runtime PM and power off
            echo auto > /sys/bus/pci/devices/0000:01:00.0/power/control
            echo 1 > /sys/bus/pci/rescan 2>/dev/null || true
          fi
        '';
        RemainAfterExit = true;
      };
    };

    # Configure VA-API for Intel
    hardware.graphics.extraPackages = lib.mkOverride 50 (with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ]);

    # Disable NVIDIA-related systemd services
    systemd.services.nvidia-powerd.enable = false;
    systemd.services.nvidia-resume.enable = false;
    systemd.services.nvidia-suspend.enable = false;
    systemd.services.nvidia-hibernate.enable = false;

    # Disable NVIDIA settings
    hardware.nvidia = {
      modesetting.enable = lib.mkForce false;
      powerManagement.enable = lib.mkForce false;
      powerManagement.finegrained = lib.mkForce false;
      dynamicBoost.enable = lib.mkForce false;
      open = lib.mkForce false;
      nvidiaSettings = lib.mkForce false;
      prime.offload.enable = lib.mkForce false;
    };

    # Environment variables for Intel GPU
    environment.variables = {
      __GLX_VENDOR_LIBRARY_NAME = "";
      DRI_PRIME = "";
    };
  };
}
