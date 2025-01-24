{ config, pkgs, lib, ... }:

let
  # customPkgs = import ~/nixpkgs/default.nix { inherit pkgs lib; };
  # allPkgs = pkgs // customPkgs;
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "fading";
  home.homeDirectory = "/home/fading";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
    "spotify"
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # MIDI Music
    audacious
    audacious-plugins

    # Audio production
    ardour
    calf
    guitarix
    gxplugins-lv2
    neural-amp-modeler-ui
    x42-plugins

    # Music
    cmus

    discord
    feh
    fzf
    gamemode
    gnupg
    gtk3
    klick
    mumble
    OVMF
    qemu
    python3Minimal

    (retroarch.override {
      cores = with libretro; [
        bsnes
        mupen64plus
      ];
    })

    ripgrep


    scrot
    solfege
    spotify
    telegram-desktop
    thunderbird
    tuxguitar

    winetricks
    wineWowPackages.full

    # nvim
    luajit

    # DOOM
    dsda-doom # custom package
    woof-doom # custom package

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/fading/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs = {
    beets = {
      enable = true;
      settings = {
        directory = "~/Music/lib";
        library = "~/.config/beets/library.db";
        plugins = "info";
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    neovim = {
        enable = true;
        plugins = with pkgs.vimPlugins; [
            packer-nvim
            nvim-lspconfig
            nvim-cmp
            cmp-nvim-lsp
            cmp_luasnip
            luasnip
            telescope-nvim
            vim-go
        ];
    };
  };

  xdg = {
    enable = true;

    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";

    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  services.picom.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
