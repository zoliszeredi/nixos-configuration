{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  imports =
    [
      ./hardware-configuration.nix
    ];
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  networking.hostName = "nixos";
  hardware = {
    opengl.driSupport = true;
    opengl.driSupport32Bit = true;
    pulseaudio.enable = true;
    pulseaudio.support32Bit = true;
    enableAllFirmware = true;
  };
  i18n = {
    consoleFont = "Fira Mono";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    inputMethod.enabled = "uim";
  };
  time.timeZone = "Europe/Bucharest";
  environment.systemPackages = with pkgs; [
    bc
    which
    unzip
    awesome
    audacity
    wget
    curl

    firefox
    chromium

    tmux
    gnupg
    gnumake
    cmake
    emacs

    neovim
    vagrant
    leiningen
    nodejs
    sbcl
    git
    zathura
    mplayer
    deluge
    fira-mono

    vagrant
    steam

    python35
    python35Packages.virtualenv
    python35Packages.docker_compose
    python35Packages.pylint

    tor

    avrdude
    avrgcclibc

    xlockmore
    xlibs.xmodmap
    xlibs.xclock
  ];
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      fira-mono
      corefonts
      inconsolata
      ubuntu_font_family
      unifont
    ];
  };
  services.openssh.enable = true;
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.windowManager.awesome.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.videoDrivers = [ "ati_unfree" ];
  programs.zsh.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.docker.enable = true;
  users.extraUsers.stz = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    uid = 1000;
  };
  users.defaultUserShell = "/run/current-system/sw/bin/zsh";
  users.extraGroups.vboxusers.members = [ "stz" ];
  users.extraGroups.docker.members = [ "stz" ];
  system.stateVersion = "16.03";
}
