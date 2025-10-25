{ config, pkgs, lib, catppuccin, user, ...}:

let
    dotfiles = ./.;
in
{
    users.users.${user} = {
      home = "/Users/${user}";
      isHidden = false;
      shell = pkgs.fish;
    };

    homebrew = {
      enable = true;
      onActivation = { autoUpdate = true; upgrade = true; cleanup = "zap"; };
      brews = [  "keyboardSwitcher" ];
      caskArgs.no_quarantine = true;
      casks = [
        {name = "ghostty"; greedy = false; }
        {name = "shortcat"; greedy = true; }
        {name = "discord"; greedy = true; }
        {name = "telegram"; greedy = false; }
        {name = "zoom"; greedy = true; }
        {name = "iina"; greedy = true; }
        {name = "raycast"; greedy = false; }
        {name = "ungoogled-chromium"; greedy = false; }
        {name = "zed"; greedy = false; }
      ];
      # $ nix shell nixpkgs#mas
      # $ mas search <app name>
      masApps = {
        "FSNotes" = 1277179284;
      };
      taps = [
        "homebrew/core"
        "homebrew/cask"
        "homebrew/bundle"
        "lutzifer/tap"
      ];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      verbose = true;

      users.${user} = {pkgs, config, lib, ...}:{
        imports = [ catppuccin.homeModules.catppuccin ];
        xdg.enable = true;
        xdg.configHome = "${config.home.homeDirectory}/.config";
        home = {
          enableNixpkgsReleaseCheck = false;
          stateVersion = "25.05";
          packages = with pkgs; [
            cowsay
            neofetch
            qmk
            nginx-language-server
          ];
          sessionVariables.SHELL = "fish";
          file = lib.mkMerge [
            { ".config/fish/conf.d/90-dotfiles-paths.fish".text = ''
              if test -d "${dotfiles}/.config/fish/functions"
                set -g fish_function_path "${dotfiles}/.config/fish/functions" $fish_function_path
              end
              if test -d "${dotfiles}/.config/fish/completions"
                set -g fish_complete_path "${dotfiles}/.config/fish/completions" $fish_complete_path
              end''; }
            { ".config/hello".text = "hello world"; }
            { "Library/LaunchAgents/environment.plist".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/environment.plist"; }
            { ".config/bat".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/bat"; }
            { ".config/git".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/git"; }
            { ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/ghostty"; }
            { ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/nvim"; }
            { ".config/zed".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/zed"; }
          ];
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
          fzf.enable = true;
          home-manager.enable = true;
          k9s.enable = true;
          starship.enable = true;
          yazi.enable = true;
        };
        catppuccin = {
          enable = true;
          flavor = "frappe";
        };
      };
    };
}
