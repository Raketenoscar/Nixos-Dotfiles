{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  services.mullvad-vpn.enable = true;
  
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    wget
    fastfetch
    unrar-wrapper
    kdePackages.dolphin
    neovim
    zoxide
    alacritty
    btop
    pfetch
    rofi
    scrcpy
    tree
    git
    wev
    bat
    yt-dlp
    mpv
    tealdeer
    fzf
    xclip
    neovim
    bluetui
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    yazi
    gcc
    pamixer
    fetch
    cava
    cmatrix
    zsh
    oh-my-zsh
    zsh-powerlevel10k
    libreoffice-fresh
    virt-manager
    chromium
    librewolf
    quickshell
    libnotify
    impala
    hyprpaper
    hyprshutdown
    hyprlock
    hyprpicker
    hyprcursor
    bibata-cursors
    opencode
    wiremix
    wlogout
    brightnessctl
    vscode
  ];
   

  fonts.packages = with pkgs; [
  dejavu_fonts
  liberation_ttf
  noto-fonts
  noto-fonts-cjk-sans
  noto-fonts-color-emoji
  corefonts
  vista-fonts
  nerd-fonts.jetbrains-mono
  nerd-fonts.fira-code
  nerd-fonts.hack
  nerd-fonts.iosevka
  fira-code
  jetbrains-mono
  hack-font
  font-awesome
  pixel-code
  ];
  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing.drivers = with pkgs; [
    gutenprint
    hplip
    brlaser
    epson-escpr
    epson-escpr2
  ];
  
  system.stateVersion = "26.05";
}
