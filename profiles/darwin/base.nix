{ userName, homeDirectory, ... }:
{
  users.users."${userName}".home = homeDirectory;
  system.primaryUser = userName;

  # nix-darwin uses a separate numeric state version from NixOS/Home Manager.
  system.stateVersion = 6;

  security.pam.services.sudo_local = {
    # Touch ID makes frequent sudo use much less annoying on a laptop.
    touchIdAuth = true;
    # This keeps Touch ID working inside tmux or other reattached shells.
    reattach = true;
  };

  programs.zsh.enable = true;

  system.activationScripts.postActivation.text = ''
    install -d -o ${userName} "${homeDirectory}/Pictures/Screenshots"
  '';

  system.defaults = {
    NSGlobalDomain = {
      # Full keyboard access makes dialogs easier to operate without the mouse.
      AppleKeyboardUIMode = 3;
      # Disabling press-and-hold restores normal key repeat in editors.
      ApplePressAndHoldEnabled = false;
      # Faster repeat feels better for Vim and general text editing.
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      # macOS text substitutions tend to get in the way for code and terminals.
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      # Save dialogs are more usable when expanded by default.
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      # Function keys default to F1-F12 so terminal/editor shortcuts behave consistently.
      "com.apple.keyboard.fnState" = true;
    };

    dock = {
      # Autohide frees vertical space on a laptop display.
      autohide = true;
      autohide-delay = 0.0;
      # Avoid macOS reshuffling Spaces based on recent use.
      mru-spaces = false;
      # Minimize into the app icon keeps the Dock tidier.
      minimize-to-application = true;
      showhidden = true;
    };

    finder = {
      # File extensions and the path bar reduce ambiguity when moving files around.
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXDefaultSearchScope = "SCcf";
      FXEnableExtensionChangeWarning = false;
      # Allow quitting Finder to fully restart it when settings get weird.
      QuitMenuItem = true;
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
    };

    trackpad = {
      # Tap-to-click and three-finger drag are common quality-of-life tweaks.
      Clicking = true;
      TrackpadThreeFingerDrag = true;
      TrackpadRightClick = true;
    };

    screencapture = {
      # PNG is predictable when sharing screenshots in docs or issues.
      type = "png";
      location = "${homeDirectory}/Pictures/Screenshots";
    };

    controlcenter = {
      # Battery percentage is useful on a laptop; Sound is usually noise.
      BatteryShowPercentage = true;
      Sound = false;
    };
  };
}
