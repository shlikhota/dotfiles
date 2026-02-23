{ user, ... }:

{
  # https://daiderd.com/nix-darwin/manual/index.html
  system.defaults = {
    controlcenter = {
      BatteryShowPercentage = false;
      Sound = true;
      Bluetooth = true;
    };
    dock = {
      autohide = true;
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
      # "icnv" = Icon view, "Nlsv" = List view, "clmv" = Column View, "Flwv" = Gallery View The default is icnv.
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
      _HIHideMenuBar = true;
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
    CustomUserPreferences = {
      "com.apple.HIToolbox" = {
        AppleCurrentKeyboardLayoutInputSourceID = "com.apple.keylayout.US";
        AppleDictationAutoEnable = 0;
        AppleEnabledInputSources = [
          {
            InputSourceKind = "Keyboard Layout";
            "KeyboardLayout ID" = 0;
            "KeyboardLayout Name" = "U.S.";
          }
          {
            InputSourceKind = "Keyboard Layout";
            "KeyboardLayout ID" = 19456;
            "KeyboardLayout Name" = "Russian";
          }
          {
            InputSourceKind = "Keyboard Layout";
            "KeyboardLayout ID" = 30778;
            "KeyboardLayout Name" = "Czech-QWERTY";
          }
          {
            "Bundle ID" = "com.apple.CharacterPaletteIM";
            InputSourceKind = "Non Keyboard Input Method";
          }
          {
            "Bundle ID" = "com.apple.PressAndHold";
            InputSourceKind = "Non Keyboard Input Method";
          }
        ];
        AppleSelectedInputSources = [
          {
            InputSourceKind = "Keyboard Layout";
            "KeyboardLayout ID" = 0;
            "KeyboardLayout Name" = "U.S.";
          }
        ];
      };
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          # 164 = Dictation shortcut (double-press Globe/Fn key)
          "164" = { enabled = 0; };
        };
      };
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

  # Login items and preference activation
  system.activationScripts.postUserActivation.text = ''
    echo "Configuring login items..."
    for app in "Raycast" "Shortcat"; do
      osascript -e "tell application \"System Events\" to delete login item \"$app\"" 2>/dev/null || true
    done
    osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Raycast.app", hidden:false}'
    osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Shortcat.app", hidden:false}'

    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
