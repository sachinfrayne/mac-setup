#!/usr/bin/env bash

brew_install_cask iterm2

defaults write com.googlecode.iterm2 "Normal Font" -string "Hack Nerd Font"
defaults write com.googlecode.iterm2 "Non Ascii Font" -string "Hack Nerd Font"

ITERM2_PREFS="$HOME/Library/Preferences/com.googlecode.iterm2.plist"
EXPORT_PATH="$HOME/Desktop/iterm2_profile_export.plist"

if [ ! -f "$ITERM2_PREFS" ]; then
  echo "iTerm2 preferences file not found at $ITERM2_PREFS"
  exit 1
fi
