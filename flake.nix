{
  description = "Kuglee nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-jetbrains-plugins = {
      url = "github:nix-community/nix-jetbrains-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-jetbrains-plugins }:
  let
    inherit (nix-jetbrains-plugins.lib) buildIdeWithPlugins;

    pkgs = import nixpkgs {
      system = "aarch64-darwin";
      config.allowUnfree = true;
    };
    ideaWithPlugins = (buildIdeWithPlugins pkgs "idea" [
      "IdeaVIM"
      "com.github.erotourtes.harpoon"
      "com.vermouthx.xcode-theme"
    ]).overrideAttrs (old: {
        disallowedReferences = [];
      });
    intellijVersion =
      let
        parts = pkgs.lib.strings.splitString "." ideaWithPlugins.version;
      in
        "${builtins.elemAt parts 0}.${builtins.elemAt parts 1}";
    configuration = { config, pkgs, ... }:
    {
      nixpkgs.overlays = [
        (import ./pkgs)
      ];

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with nix-jetbrains-plugins.lib;
        [ pkgs.neovim
          pkgs.git
          pkgs.ffmpeg
          pkgs.yt-dlp
          pkgs.mkcert
          pkgs.nss
          pkgs.imagemagick
          pkgs.ripgrep
          pkgs.swiftformat
          pkgs.xcbeautify
          pkgs.swiftformat
          pkgs.ghostty-bin
          pkgs.elmPackages.elm
          pkgs.elmPackages.elm-format
          pkgs.elmPackages.elm-optimize-level-2
          pkgs.rtorrent
          pkgs.yabai
          pkgs.yazi
          pkgs.mas
          pkgs.tree-sitter
          ideaWithPlugins
          pkgs.defaultbrowser
          pkgs.lazygit
          pkgs.btop

          # GUI apps
          pkgs.appcleaner
          pkgs.brave
          pkgs.keka
          pkgs.mkvtoolnix

          # Custom apps
          pkgs.bettertouchtool
          pkgs.kinesis-smart-set-app
          pkgs.forklift
          pkgs.injection-next
          pkgs.sf-symbols
        ];
      system.activationScripts.installMasApps.text = ''
       /usr/bin/env mas install 1136220934 # Infuse
       /usr/bin/env mas install 1451685025 # WireGuard
      '';

      fonts.packages = [
        pkgs.nerd-fonts.monaspace
      ];

      nixpkgs.config.allowUnfree = true;
      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = ["/Applications"];
        };
      in
        pkgs.lib.mkForce ''
          # Set up applications.
          echo "setting up /Applications..." >&2
          rm -rf /Applications/Nix\ Apps
          mkdir -p /Applications/Nix\ Apps
          find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read -r src; do
            app_name=$(basename "$src")
            echo "copying $src" >&2
                    ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          done
        '';

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      system.primaryUser = "kuglee";
      users.users.kuglee.home = "/Users/kuglee";

      system.defaults = {
        NSGlobalDomain.ApplePressAndHoldEnabled = false;
        NSGlobalDomain.AppleShowAllExtensions = true;
        NSGlobalDomain.AppleWindowTabbingMode = "always";
        NSGlobalDomain.InitialKeyRepeat = 25;
        NSGlobalDomain.KeyRepeat = 2;
        NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
        NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
        NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
        NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
        ActivityMonitor.ShowCategory = 100;
        ActivityMonitor.SortColumn = "CPUUsage";
        ActivityMonitor.SortDirection = 0;
        WindowManager.EnableStandardClickToShowDesktop = false;
        WindowManager.StandardHideDesktopIcons = false;
        controlcenter.NowPlaying = false;
        controlcenter.Sound = true;
        dock.autohide = true;
        dock.orientation = "right";
        dock.persistent-apps = [];
        dock.show-process-indicators = false;
        dock.show-recents = false;
        dock.showMissionControlGestureEnabled = true;
        dock.tilesize = 1;
        dock.wvous-br-corner = 1;
        finder.AppleShowAllExtensions = true;
        finder.CreateDesktop = false;
        finder.FXPreferredViewStyle = "clmv";
        finder.NewWindowTarget = "Other";
        finder.NewWindowTargetPath = "~/Downloads";
        finder.ShowPathbar = true;
        finder.ShowStatusBar = true;
        finder._FXEnableColumnAutoSizing = true;
        loginwindow.GuestEnabled = false;
        screencapture.disable-shadow = true;
        screencapture.target = "preview";
        trackpad.TrackpadFourFingerHorizSwipeGesture = 2;
        trackpad.TrackpadFourFingerVertSwipeGesture = 2;
        trackpad.TrackpadPinch = true;
        trackpad.TrackpadThreeFingerDrag = true;

        CustomUserPreferences = {
          NSGlobalDomain = {
            AppleMenuBarVisibleInFullscreen = true;
            TSMLanguageIndicatorEnabled = false;
            AppleReduceDesktopTinting = true;
          };

          "com.brave.Browser" = {
            SUAutomaticallyUpdate = false;
            SUEnableAutomaticChecks = false;
            SUHasLaunchedBefore = true;
          };

          "net.freemacsoft.AppCleaner" = {
            SUAutomaticallyUpdate = false;
            SUEnableAutomaticChecks = false;
            SUHasLaunchedBefore = true;
          };

          "com.binarynights.ForkLift" = {
            SUAutomaticallyUpdate = false;
            SUEnableAutomaticChecks = false;
            SUHasLaunchedBefore = true;
            setupDone = true;
          };

          "org.m0k.transmission" = {
            SUAutomaticallyUpdate = false;
            SUEnableAutomaticChecks = false;
            SUHasLaunchedBefore = true;
          };
        };
      };

      system.keyboard.enableKeyMapping = true;
      system.keyboard.remapCapsLockToControl = true;

      services.yabai.enable = true;
      services.yabai.enableScriptingAddition = true;
      services.yabai.config = {
        window_animation_duration = 0.0;
        window_opacity_duration = 0.0;
      };

      system.activationScripts.postActivation.text = let
        plistFormat = pkgs.formats.plist { };
        bravePlist = plistFormat.generate "com.brave.Browser.plist" {
          AlternateErrorPagesEnabled = false;
          AutofillCreditCardEnabled = false;
          BackgroundModeEnabled = false;
          BookmarkBarEnabled = false;
          BraveAIChatEnabled = false;
          BraveNewsDisabled = true;
          BraveP3AEnabled = false;
          BraveRewardsDisabled = true;
          BraveSpeedreaderEnabled = false;
          BraveStatsPingEnabled = false;
          # BraveSyncUrl = "";
          BraveTalkDisabled = true;
          BraveVPNDisabled = true;
          BraveWalletDisabled = true;
          BraveWaybackMachineEnabled = false;
          BraveWebDiscoveryEnabled = false;
          BrowserGuestModeEnabled = false;
          BrowserSignin = 0;
          BuiltInDnsClientEnabled = false;
          CloudReportingEnabled = false;
          DefaultBrowserSettingEnabled = true;
          DefaultGeolocationSetting = 2;
          DefaultLocalFontsSetting = 2;
          DefaultNotificationsSetting = 2;
          DefaultSearchProviderEnabled = true;
          DefaultSearchProviderName = "Google";
          DefaultSearchProviderSearchURL = "www.google.com";
          DefaultSensorsSetting = 2;
          DefaultSerialGuardSetting = 2;
          DeviceActivityHeartbeatEnabled = false;
          DeviceMetricsReportingEnabled = false;
          DriveDisabled = true;
          ExtensionInstallForcelist = [
            "edlhclhffmclbhgifomamlomnfolnepa" # Elm Debug Helper
            "pejdijmoenmkgeppbflobdenhhabjlaj" # iCloud Passwords
          ];
          ExtensionManifestV2Availability = 2;
          HeartbeatEnabled = false;
          IncognitoModeAvailability = 1;
          LogUploadEnabled = false;
          MemorySaverEnabled = true;
          MetricsReportingEnabled = false;
          ParcelTrackingEnabled = false;
          PasswordLeakDetectionEnabled = false;
          PasswordManagerEnabled = false;
          PasswordSharingEnabled = false;
          QuickAnswersEnabled = false;
          RelatedWebsiteSetsEnabled = false;
          ReportAppInventory = [ "" ];
          ReportDeviceActivityTimes = false;
          ReportDeviceAppInfo = false;
          ReportDeviceSystemInfo = false;
          ReportDeviceUsers = false;
          ReportWebsiteTelemetry = [ "" ];
          SafeBrowsingDeepScanningEnabled = false;
          SafeBrowsingExtendedReportingEnabled = false;
          SafeBrowsingSurveysEnabled = false;
          ShoppingListEnabled = false;
          ShowHomeButton = false;
          # SyncDisabled = true;
          TorDisabled = true;
          WebAppInstallForceList = [
            {
              url = "https://www.facebook.com/?ref=homescreenpwa";
              default_launch_container = "window";
            }
          ];
        };
      in ''
        # Make the menu bar settings take effect for running applications
        sudo -u $USER osascript -l JavaScript -e 'ObjC.import("Foundation"); $.NSDistributedNotificationCenter.defaultCenter.postNotificationNameObject("AppleInterfaceFullScreenMenuBarVisibilityChangedNotification", $())'

        # Debloat Brave
        # from: https://gist.github.com/yashgorana/be2368c04c0ec11b6e21c57a229a65ca
        mkdir -p /Library/Managed\ Preferences/
        cp -f ${bravePlist} /Library/Managed\ Preferences/com.brave.Browser.plist
        chmod 644 /Library/Managed\ Preferences/com.brave.Browser.plist

        # Set Brave as the default browser
        # NOTE: this will show a popup if the browser is not already the default
        "${pkgs.defaultbrowser}/bin/defaultbrowser" browser
      '';

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#macbook
    darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit intellijVersion; };
            users.kuglee = home/home.nix;
          };
        }
      ];
    };
  };
}

