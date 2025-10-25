{ user, ... }:

{
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
}
