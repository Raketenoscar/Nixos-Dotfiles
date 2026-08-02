{ config, pkgs, ... }:

{
  home.username = "oscar";
  home.homeDirectory = "/home/oscar";
  home.stateVersion = "26.05";

# Dark Mode
    gtk = {
    enable = true;

    colorScheme = "dark";

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
    home.sessionVariables = {
    GTK_THEME = "Adwaita:dark";

    QT_QPA_PLATFORMTHEME = "gtk3";
    QT_STYLE_OVERRIDE = "Adwaita-dark";

    MOZ_ENABLE_WAYLAND = "1";
  };
   dconf = {
    enable = true;

    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

#Zsh
  programs.zsh = {
    enable = true;
    shellAliases = {
                        config = "nvim /home/oscar/nixos/configuration.nix";
                        hardware-config = "nvim /home/oscar/nixos/hardware-configuration.nix";
                        pkgs = "nvim /home/oscar/nixos/pkgs.nix";
                        home-config = "nvim /home/oscar/nixos/home.nix";
                        nrs = "git -C /home/oscar/nixos add -A; sudo nixos-rebuild switch --flake /home/oscar/nixos";
			                  update = "nix flake update --flake /home/oscar/nixos; sudo nixos-rebuild switch --flake /home/oscar/nixos";
                        user-config = "nvim /home/oscar/nixos/user.nix";
                        internet = "impala";
                        conf = "cd /home/oscar/nixos/config/";
                        neofetch = "bash /home/oscar/nixos/config/neofetch/neofetch.sh";
                        dot = "cd /home/oscar/nixos";
                        freespace = "sudo nix-collect-garbage -d; git -C /home/oscar/nixos add -A; sudo nixos-rebuild switch --flake /home/oscar/nixos";
                        rocketserver = "ssh oscar@192.168.88.51";
    };
    oh-my-zsh = {
      enable = true;
      custom = "/home/oscar/nixos/config/oh-my-zsh/custom";
      theme = "powerlevel10k";
      plugins = [
        "git"
        "sudo"
        "docker"
        "dirhistory"
        "history"
      ];
    };
    initContent = ''
        source /home/oscar/nixos/config/p10k/.p10k.zsh
        eval "$(zoxide init --cmd cd zsh)"
        pfetch
      '';
};


# Alacritty
    programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        primary = {
          background = "#1a1b26";
          foreground = "#c0caf5";
        };
      };
      font.normal = {
        family = "JetBrains Mono Nerd Font";
        style = "Regular";
      };
      font.size = 12;
    };
  };

# Quickshell
  xdg.configFile."quickshell" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/oscar/nixos/config/quickshell";
    recursive = true;
  };

# Hypr
    xdg.configFile."hypr" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/oscar/nixos/config/hypr";
    recursive = true;
  };
# Wlogout
    xdg.configFile."wlogout" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/oscar/nixos/config/wlogout";
    recursive = true;
  };

# Rofi
  xdg.configFile."rofi".source = ./config/rofi;

# NVIM
  xdg.configFile."nvim".source = ./config/nvim;

# Wallpapers
  home.file."walls".source = ./walls;

# Cursor
  home.file.".local/share/icons".source = ./config/cursors;

# Desktop Files
  home.file.".local/share/applications".source = ./desktop-files;

}
