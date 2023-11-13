#!/usr/bin/env bash

brew tap homebrew/cask-fonts
brew_install_cask font-hack-nerd-font

defaults write com.googlecode.iterm2 "Normal Font" -string "Hack Nerd Font"
defaults write com.googlecode.iterm2 "Non Ascii Font" -string "Hack Nerd Font"
