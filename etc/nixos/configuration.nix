# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.efi.canTouchEfiVariables = true;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "nodev"; # or "nodev" for efi only

  networking.hostName = "brokoli"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  # networking.wireless.iwd.enable = true;
  # networking.networkmanager.wifi.backend = "iwd";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };


  services = {
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      autorun = false;

      desktopManager = {
        xterm.enable = false;
      };

      displayManager = {

        startx.enable = true;
        sessionCommands = ''
          xinput set-prop "Logitech Gaming Mouse G502" "libinput Middle Emulation Enabled" 0
        '';

        setupCommands = ''
          LEFT='HDMI-0'
          RIGHT='DVI-D-0'
          ${pkgs.xorg.xrandr}/bin/xrandr --output "$RIGHT" --primary --mode 1920x1080 --rate 144.00 --output "$LEFT" --left-of "$RIGHT" --mode 1920x1080 --rate 60.00

          MOUSE='Logitech Gaming Mouse G502'
          xinput set-prop "$MOUSE" "libinput Middle Emulation Enabled" 0
        '';
      };

      monitorSection = ''
        Option "Primary" "DVI-D-0: true, HDMI-0: false"
        Option "Modeline" "DVI-D-0: 1920x1080_144.00, HDMI-0: 1920x1080_60.00"
        Option "LeftOf" "HDMI-0: DVI-D-0"
        Option "RightOf" "DVI-D-0: HDMI-0"
      '';

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
          i3status
          i3lock
        ];
      };

      videoDrivers = [ "nvidia" ];

      # Configure keymap
      xkb = {
        layout = "de,us";
        variant = "neo_qwertz,";
        options = "grp:win_space_toggle";
      };
    };

    displayManager.defaultSession = "none+i3";

    # Enable CUPS to print documents.
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
    };

    udev = {
      # extraRules = ''
      #   SUBSYSTEM=="usb", ATTRS{idVendor}=="0fce", MODE="0666", TAG+="uaccess"
      #   SUBSYSTEM=="usb_device", ATTRS{idVendor}=="0fce", MODE="0666", TAG+="uaccess"
      # '';
      packages = [
        pkgs.android-udev-rules
      ];
    };

    pipewire.enable = false;
  };

  # hardware.printers = {
  #   ensurePrinters = [
  #     {
  #       name = "HP_Laserjet";
  #       location = "Home";
  #       deviceUri = "dnssd://HP%20LaserJet%20MFP%20M28w%20(7C35F7)._ipp._tcp.local/?uuid=564e4333-5335-3537-3039-80e82c7c35f7";
  #       model = "everywhere";
  #       ppdOptions = {
  #         PageSize = "A4";
  #       };
  #     }
  #   ];
  #   ensureDefaultPrinter = "HP_Laserjet";
  # };

  # Enable sound.
  # sound.enable = true;
  hardware = {
    nvidia = {

      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of 
      # supported GPUs is at: 
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    pulseaudio.enable = true;
  };

  # services.jack = {
  #   jackd.enable = true;
  #   # support ALSA only programs via ALSA JACK PCM plugin
  #   alsa.enable = false;
  #   # support ALSA only programs via loopback device (supports programs like Steam)
  #   loopback = {
  #     enable = true;
  #     # buffering parameters for dmix device to work with ALSA only semi-professional sound programs
  #     #dmixConfig = ''
  #     #  period_size 2048
  #     #'';
  #   };
  # };

  # doas
  security.doas = {
    enable = true;
    extraRules = [
      { groups = [ "wheel" ]; noPass = false; persist = true; keepEnv = true; }
      { groups = [ "wheel" ]; noPass = true; cmd = "shutdown"; }
      { groups = [ "wheel" ]; noPass = true; cmd = "reboot"; }
    ];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Add extra groups
  users.groups = {
    adbusers = {};
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fading = {
    isNormalUser = true;
    home = "/home/fading";
    extraGroups = [
      "adbusers"
      "audio"
      # "jackaudio"
      "wheel"
    ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    # packages = with pkgs; [
    #   firefox
    # ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11"
    "nvidia-settings"
    "steam"
    "steam-original"
    "steam-unwrapped"
    "steam-run"
  ];

  programs = {
    adb.enable = true;
    dconf.enable = true;
    firefox.enable = true;
    steam.enable = true;
    zsh.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    cmake
    coreutils
    emacs
    evince
    gcc
    git
    adwaita-icon-theme
    gnumake
    isabelle
    # jack2
    # jackmix
    man-pages
    man-pages-posix
    muse
    nodejs
    openzone-cursors
    pulsemixer
    texlive.combined.scheme-full
    unzip
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    xournalpp
  ];

  virtualisation = {
      podman = {
          enable = true;
          dockerCompat = true;
      };
  };

  fonts.packages = with pkgs; [
    iosevka
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

