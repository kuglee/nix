{
  description = "Kuglee nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.neovim
          pkgs.git
          pkgs.ffmpeg
          pkgs.yt-dlp
          pkgs.mkcert
          pkgs.imagemagick
          pkgs.ripgrep
          pkgs.swiftformat
          pkgs.xcbeautify
          pkgs.swiftformat
          pkgs.ghostty-bin
          pkgs.elmPackages.elm
          pkgs.elmPackages.elm-format
          pkgs.elmPackages.elm-optimize-level-2
        ];

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

          "com.apple.Safari" = {
            # General
            AutoOpenSafeDownloads = false;
            CanPromptForPushNotifications = false;

            # Restore last session at launch
            AlwaysRestoreSessionAtLaunch = true;
            ExcludePrivateWindowWhenRestoringSessionAtLaunch = true;
            OpenPrivateWindowWhenNotRestoringSessionAtLaunch = false;

            # Developer menu (also need to enable this: com.apple.Safari.SandboxBroker.ShowDevelopMenu)
            IncludeDevelopMenu = true;
          };

          # Developer menu (also need to enable this: com.apple.Safari.IncludeDevelpMenu)
          "com.apple.Safari.SandboxBroker" = {
            ShowDevelopMenu = true;
          };
        };
      };
      system.keyboard.enableKeyMapping = true;
      system.keyboard.remapCapsLockToEscape = true;

      # services.yabai.enable = true;
      # services.yabai.enableScriptingAddition = true;
      # services.yabai.config = {
      #   window_animation_duration = 0.0;
      #   window_opacity_duration = 0.0;
      # };

      system.activationScripts.postActivation.text = ''
        # Make the menu bar settings take effecct for running applications
        sudo -u $USER osascript -l JavaScript -e 'ObjC.import("Foundation"); $.NSDistributedNotificationCenter.defaultCenter.postNotificationNameObject("AppleInterfaceFullScreenMenuBarVisibilityChangedNotification", $())'
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
            users.kuglee = home/home.nix;
          };
        }
      ];
    };
  };
}

