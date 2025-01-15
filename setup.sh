#!/usr/bin/env bash

set -euo pipefail

brew_install() {
  if ! brew ls --versions "$1" >/dev/null; then
    brew install "$1"
  fi
}

brew_install devtoys
brew_install docker-compose
brew_install htop
brew_install jq
brew_install kubectl
brew_install kubectx
brew_install minikube
brew_install node

brew_install_cask() {
  if ! brew ls --versions --cask "$1" >/dev/null; then
    brew install --cask "$1"
  fi
}

brew_install_cask alfred
brew_install_cask alt-tab
brew_install_cask docker
brew_install_cask espanso
brew_install_cask font-hack-nerd-font
brew_install_cask iterm2
brew_install_cask lens
brew_install_cask postman
brew_install_cask visual-studio-code
brew_install_cask zed

for F in $LIB/*.sh; do
  echo "Check for $(echo $F | sed 's|'$LIB'/||g' | sed 's|\.sh||g')"
  source $F
done
