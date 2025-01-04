{ pkgs, catppuccin, ...}:

let
  user = "evgenii";
in
{
    programs.zsh.enable = true;
    programs.fish.enable = true;

    users.users.${user} = {
      name = "${user}";
      home = "/Users/${user}";
      isHidden = false;
      shell = pkgs.fish;
    };

    homebrew = {
      enable = true;
      brews = [
        "keyboardSwitcher"
      ];
      casks = [
        "homebrew/cask/docker"
        "ghostty"
        "shortcat"
        "discord"
        "telegram"
        "zoom"
        "iina"
        "raycast"
        "google-chrome"
        "zed"
      ];
      # $ nix shell nixpkgs#mas
      # $ mas search <app name>
      masApps = {
        "FSNotes" = 1277179284;
      };
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      verbose = true;
      users.${user} = {pkgs, config, lib, ...}:{
        imports = [
          catppuccin.homeManagerModules.catppuccin
        ];
        home = {
          enableNixpkgsReleaseCheck = false;
          packages = [
            pkgs.cowsay
            pkgs.neofetch
          ];
          file = lib.mkMerge [
            { ".config/hello".text = "hello world"; }
            { "Library/LaunchAgents/environment.plist".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/environment.plist"; }
            { ".config/git".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/git"; }
            { ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/ghostty"; }
            { ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/nvim"; }
            { ".config/zed".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/zed"; }
          ];
          stateVersion = "25.05";
        };
        programs = {
          fish.enable = true;
          starship.enable = true;
          home-manager.enable = true;
        };
        catppuccin.enable = true;
        catppuccin.flavor = "frappe";
        catppuccin.zed.enable = false;
      };
    };
}
