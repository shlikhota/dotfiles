{
  description = "System flake configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
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

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-homebrew, homebrew-bundle, homebrew-core, homebrew-cask, kbs-tap, catppuccin, ... }:
  let
    user = "evgenii";
    darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];

    systemConfiguration = { pkgs, config, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      programs.zsh.enable = true;
      programs.fish.enable = true;

      environment.systemPackages =
        [
          pkgs.fd
          pkgs.fish
          pkgs.fzf
          pkgs.git
          pkgs.go
          pkgs.golangci-lint
          pkgs.gopls
          pkgs.jq
          pkgs.k9s
          pkgs.mkalias
          pkgs.neovim
          pkgs.ripgrep
          pkgs.speedtest-cli
          pkgs.starship
          pkgs.sshs
        ];

      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];

      system = {
        stateVersion = 5;
        # Set Git commit hash for darwin-version.
        configurationRevision = self.rev or self.dirtyRev or null;
        # https://daiderd.com/nix-darwin/manual/index.html
        defaults = {
          controlcenter.BatteryShowPercentage = false;
          dock = {
            autohide = false;
            show-recents = false;
            launchanim = true;
            orientation = "bottom";
            tilesize = 48;
            # run screensaver on bottom left corner
            wvous-bl-corner = 5;
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
            "com.apple.Safari" = {
              "ShowOverlayStatusBar" = true;
              "AlwaysRestoreSessionAtLaunch" = true;
              "UniversalSearchEnabled" = false;
              "SuppressSearchSuggestions" = true;
              "ShowFullURLInSmartSearchField" = true;
              "HomePage" = "about:blank";
              "AutoOpenSafeDownloads" = false;
              # Disable Safari’s thumbnail cache for History and Top Sites
              "DebugSnapshotsUpdatePolicy" = -2;
              # Enable Safari’s debug menu
              "IncludeInternalDebugMenu" = true;
              # Enable the Develop menu and the Web Inspector in Safari
              "IncludeDevelopMenu" = true;
              "WebKitDeveloperExtrasEnabledPreferenceKey" = true;
              "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
              "WebAutomaticSpellingCorrectionEnabled" = false;
              "WebContinuousSpellCheckingEnabled" = true;
              # Disable Java
              "WebKitJavaEnabled" = false;
              "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled" = false;
              "SendDoNotTrackHTTPHeader" = true;
              "StatusMenuVisible" = true;
            };
            "com.apple.DiskUtility" = {
              "DUDebugMenuEnabled" = true;
              "advanced-image-options" = true;
            };
            "com.apple.ImageCapture" = {
              "disableHotPlug" = true;
            };
            "com.apple.print.PrintingPrefs" = {
              "Quit When Finished" = true;
            };
            "com.apple.desktopservices" = {
              "DSDontWriteNetworkStores" = true;
              "DSDontWriteUSBStores" = true;
            };
          };
          screensaver = {
            askForPassword = true;
            askForPasswordDelay = 0;
          };
          screencapture = {
            location = "~/Documents/screenshots/";
            type = "png";
          };
          trackpad = {
            Clicking = true;
            TrackpadThreeFingerDrag = true;
          };
        };
      };

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    darwinConfigurations."home" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = inputs;
      modules = [
        home-manager.darwinModules.home-manager
        systemConfiguration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            inherit user;
            enable = true;
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
              "lutzifer/homebrew-tap" = kbs-tap;
            };
            mutableTaps = false;
            autoMigrate = true;
          };
        }
        ./home.nix
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."home".pkgs;
  };
}
