{ config, pkgs, catppuccin, ...}:

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
      global.autoUpdate = false;
      onActivation = {
        autoUpdate = true;
        upgrade = true;
        cleanup = "zap";
      };
      brews = [
        "keyboardSwitcher"
      ];
      caskArgs.no_quarantine = true;
      casks = [
        {name = "homebrew/cask/docker"; greedy = true; }
        {name = "ghostty"; greedy = true; }
        {name = "shortcat"; greedy = false; }
        {name = "discord"; greedy = true; }
        {name = "telegram"; greedy = true; }
        {name = "zoom"; greedy = true; }
        {name = "iina"; greedy = true; }
        {name = "raycast"; greedy = true; }
        {name = "google-chrome"; greedy = true; }
        {name = "zed"; greedy = true; }
      ];
      # $ nix shell nixpkgs#mas
      # $ mas search <app name>
      masApps = {
        "FSNotes" = 1277179284;
      };
      taps = builtins.attrNames config.nix-homebrew.taps;
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      verbose = true;
      users.${user} = {pkgs, config, lib, ...}:{
        imports = [
          catppuccin.homeModules.catppuccin
        ];
        home = {
          enableNixpkgsReleaseCheck = false;
          packages = [
            pkgs.cowsay
            pkgs.neofetch
            pkgs.qmk
          ];
          file = lib.mkMerge [
            { ".config/hello".text = "hello world"; }
            { "Library/LaunchAgents/environment.plist".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/environment.plist"; }
            { ".config/bat".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/bat"; }
            { ".config/git".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/git"; }
            { ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/ghostty"; }
            { ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/nvim"; }
            { ".config/zed".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/zed"; }
          ];
          stateVersion = "25.05";
        };
        programs = {
          fish = {
            enable = true;
            shellInit = ''
              set -g fish_key_bindings fish_vi_key_bindings
            '';
            shellAliases = {
              ga = "git add";
              gc = "git commit";
              gco = "git checkout";
              gcp = "git cherry-pick";
              gdiff = "git diff";
              gp = "git push";
              gs = "git status";
              gt = "git tag";
            };
          };
          starship.enable = true;
          home-manager.enable = true;
        };
        catppuccin.enable = true;
        catppuccin.flavor = "frappe";
        catppuccin.zed.enable = false;
      };
    };
}
