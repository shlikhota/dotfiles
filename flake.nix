{
  description = "System flake configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin.url = "github:catppuccin/nix";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    kbs-tap = {
      url = "github:lutzifer/homebrew-tap";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-homebrew, catppuccin, ... }:
  let
    user = "evgenii";
    allowUnfreePackages = [ "claude-code" ];
    lib = inputs.nixpks.lib;
    pkgsStable = import inputs.nixpkgs {
      system = "aarch64-darwin";
      config = {
        allowUnfree = true;
        allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) allowUnfreePackages;
      };
    };
    pkgsUnstable = import inputs.nixpkgs-unstable {
      system = "aarch64-darwin";
      config = {
        allowUnfree = true;
        allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) allowUnfreePackages;
      };
    };

    systemConfiguration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      nix = {
        settings.experimental-features = [ "nix-command" "flakes" ];
        gc = { automatic = true; options = "--delete-older-than 14d"; };
        optimise.automatic = true;
      };

      programs = {
        zsh.enable = true;
        fish.enable = true;
      };

      environment.variables = {
        EDITOR = "nvim";
      };

      environment.systemPackages = with pkgs; [
        bat
        claude-code
        fd
        fish
        fzf
        git
        go
        golangci-lint
        gopls
        jq
        k9s
        neovim
        nixd
        ollama
        ripgrep
        speedtest-cli
        starship
        sshs
        yazi
      ];

      fonts = {
        packages = with pkgs; [
          nerd-fonts.jetbrains-mono
        ];
      };

      system = {
        stateVersion = 5;
        # Set Git commit hash for darwin-version.
        configurationRevision = self.rev or self.dirtyRev or null;
        primaryUser = user;
        # https://daiderd.com/nix-darwin/manual/index.html
        defaults = {
          controlcenter = {
            BatteryShowPercentage = false;
            Sound = true;
            Bluetooth = true;
          };
          dock = {
            autohide = false;
            show-recents = false;
            launchanim = true;
            orientation = "bottom";
            tilesize = 48;
            # run screensaver on bottom left corner
            wvous-bl-corner = 5;
            persistent-apps = [
              "/System/Applications/Calendar.app/"
              "/Applications/Safari.app/"
              "/Applications/Zed.app/"
              "/Applications/Ghostty.app/"
              "/Applications/Telegram.app/"
              "/Applications/Raycast.app/"
              "/System/Applications/App Store.app/"
            ];
          };
          finder = {
            _FXShowPosixPathInTitle = true;
            _FXSortFoldersFirst = true;
            AppleShowAllFiles = true;
            ShowStatusBar = true;
            ShowPathbar = true;
            FXEnableExtensionChangeWarning = false;
            # “icnv” = Icon view, “Nlsv” = List view, “clmv” = Column View, “Flwv” = Gallery View The default is icnv.
            FXPreferredViewStyle = "Nlsv";
            NewWindowTarget = "Home";
          };
          loginwindow.GuestEnabled = false;
          menuExtraClock = {
            IsAnalog = false;
            Show24Hour = true;
            ShowDate = 2;
            ShowSeconds = true;
          };
          NSGlobalDomain = {
            AppleICUForce24HourTime = true;
            AppleShowAllExtensions = true;
            AppleShowAllFiles = true;
            AppleShowScrollBars = "Always";
            # 120, 90, 60, 30, 12, 6, 2
            KeyRepeat = 2;
            # 120, 94, 68, 35, 25, 15
            InitialKeyRepeat = 15;
            NSAutomaticCapitalizationEnabled = false;
            NSAutomaticDashSubstitutionEnabled = false;
            NSAutomaticPeriodSubstitutionEnabled = false;
            NSAutomaticQuoteSubstitutionEnabled = false;
            NSAutomaticSpellingCorrectionEnabled = false;
            NSNavPanelExpandedStateForSaveMode = true;
            NSNavPanelExpandedStateForSaveMode2 = true;
            PMPrintingExpandedStateForPrint = true;
            PMPrintingExpandedStateForPrint2 = true;
          };
          CustomSystemPreferences = {
            "com.apple.DiskUtility" = {
              "DUDebugMenuEnabled" = true;
              "advanced-image-options" = true;
            };
            "com.apple.ImageCapture".disableHotPlug = true;
            "com.apple.mail".DisableInlineAttachmentViewing = true;
            "com.apple.SoftwareUpdate" = {
              "AutomaticCheckEnabled" = true;
              "ScheduleFrequency" = 1; # weekly
              "AutomaticDownload" = 1;
              "CriticalUpdateInstall" = 1;
            };
            "com.apple.print.PrintingPrefs" = {
              "Quit When Finished" = true;
            };
            "com.apple.desktopservices" = {
              "DSDontWriteNetworkStores" = true;
              "DSDontWriteUSBStores" = true;
            };
          };
          screencapture = {
            location = "/Users/${user}/Documents/";
            type = "png";
          };
          trackpad = {
            Clicking = true;
            TrackpadThreeFingerDrag = true;
          };
          WindowManager.EnableStandardClickToShowDesktop = false;
        };
        # activationScripts.postActivation.text = ''
        # '';
      };
      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    darwinConfigurations."home" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {
          inherit catppuccin;
          inherit user;
      };
      modules = [
        { nixpkgs = {
            pkgs = pkgsStable;
            overlays = [ (final: prev: { unstable = pkgsUnstable; }) ];
          };
        }
        home-manager.darwinModules.home-manager
        systemConfiguration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            inherit user;
            enable = true;
            mutableTaps = false;
            autoMigrate = true;
            taps = {
              "homebrew/homebrew-core" = inputs.homebrew-core;
              "homebrew/homebrew-cask" = inputs.homebrew-cask;
              "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
              "lutzifer/homebrew-tap" = inputs.kbs-tap;
            };
          };
        }
        ./home.nix
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."home".pkgs;
  };
}
