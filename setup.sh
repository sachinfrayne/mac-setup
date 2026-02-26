#!/usr/bin/env bash

set -euo pipefail

brew_upgrade() {
	brew update
	brew upgrade
	brew upgrade --cask
	brew cleanup
	echo "Upgrade Complete!"
}

if [[ "${1:-}" == "--upgrade" ]]; then
	brew_upgrade
	exit 0
fi

brew_install() {
	if ! brew list --formula "$1" >/dev/null 2>&1; then
		brew install "$1"
	fi
}

brew_install docker-compose
brew_install gemini-cli
brew_install gh
brew_install gradle
brew_install helm
brew_install htop
brew_install imagemagick
brew_install jq
brew_install kcat
brew_install kubectl
brew_install kubectx
brew_install minikube
brew_install node
brew_install nvm
brew_install ollama
brew_install shfmt
brew_install skopeo
brew_install stern
brew_install terraform
brew_install uv
brew_install watch
brew_install yarn

brew_install_cask() {
	if ! brew list --cask "$1" >/dev/null 2>&1; then
		brew install --cask "$1"
	fi
}

brew_install_cask alt-tab
brew_install_cask claude-code
brew_install_cask cursor
brew_install_cask devtoys
brew_install_cask docker
brew_install_cask espanso
brew_install_cask font-hack-nerd-font
brew_install_cask gcloud-cli
brew_install_cask intellij-idea-ce
brew_install_cask iterm2
brew_install_cask lens
brew_install_cask lulu
brew_install_cask postman
brew_install_cask raycast
brew_install_cask visual-studio-code
brew_install_cask webstorm
brew_install_cask zed

for F in ${HOME}/Source/mac-setup/bin/*.sh; do
	source $F
done

echo "Install Complete!"
