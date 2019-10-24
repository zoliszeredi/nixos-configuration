{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.firefox.enableAdobeFlash = true;
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "znixos"; 
  networking.wireless.enable = true;

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };
  time.timeZone = "Europe/Bucharest";
  environment = {
    variables = {
      EDITOR = "emacs";
    };
    systemPackages = with pkgs; [
      bc
      which
      zip
      unzip
      unrar
      p7zip
      awesome
      wget
      curl
      usbutils

      firefox
      thunderbird
      chromium

      tmux
      gnupg
      gnumake
      zbar
      scrot
      cmake
      
      vim
      emacs

      aspell
      aspellDicts.hu
      aspellDicts.en
      aspellDicts.ro
  
      hunspell
      hunspellDicts.hu-hu
      hunspellDicts.en-us

      gcc
      rlwrap
      rxvt_unicode-with-plugins
      sqlite

      openvpn
      networkmanagerapplet
      pavucontrol

      git
      zathura
      vlc
      deluge
      audacity

      dosbox
      steam
      eagle
      spotify

      python37
      python37Packages.ipython
      python37Packages.black
      python37Packages.flake8
      # pypy3

      docker-compose
      vagrant
      tor

      lshw
      gparted
      cargo

      xlockmore
      xlibs.xmodmap
      xlibs.xclock
    ];
  };

  # look at: https://nixos.wiki/wiki/Home_Manager

  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.ssh.startAgent = true;
  programs.zsh = {
    enable = true;
    # autosuggestions.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "docker"
        "git-extras"
        "git"
      ];
      # theme = "dst";
      theme = "minimal";
    };
  };

  services.openssh.enable = true;
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.windowManager.awesome.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.printing.enable = true;
  sound.enable = true;
  hardware = {
    opengl.enable = true;
    opengl.driSupport = true;
    opengl.driSupport32Bit = true;
    pulseaudio.enable = true;
    pulseaudio.support32Bit = true;
    enableAllFirmware = true;
  };

  services.xserver.libinput.enable = true;
  # services.xserver.synaptics.enable = true;

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_11;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all ::1/128 trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE nixcloud WITH LOGIN PASSWORD 'nixcloud' CREATEDB;
      CREATE DATABASE nixcloud;
      GRANT ALL PRIVILEGES ON DATABASE nixcloud TO nixcloud;
    '';
  };
  services.redis.enable = true;
  services.memcached.enable = true;
  services.rabbitmq.enable = true;

  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.docker.enable = true;
  users.users.stz = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    uid = 1000;
  };
  users.defaultUserShell = "/run/current-system/sw/bin/zsh";
  users.extraGroups.vboxusers.members = [ "stz" ];
  users.extraGroups.docker.members = [ "stz" ];

  system.stateVersion = "19.03";

}
