#!/usr/bin/env bash

set -euo pipefail

MAC_SETUP_VERBOSE=0
if [[ "${1:-}" == "--verbose" || "${1:-}" == "-v" ]]; then
	MAC_SETUP_VERBOSE=1
	shift
fi
export MAC_SETUP_VERBOSE

usage() {
	cat <<'EOF'
Usage: mac [--verbose|-v] [--upgrade] [--help|-h]

Options:
  --verbose, -v   Print extra progress details (and unsuppress some output).
  --upgrade       Run Homebrew update/upgrade/cleanup and exit.
  --help, -h      Show this help and exit.
EOF
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
	usage
	exit 0
fi

log() {
	if [[ "${MAC_SETUP_VERBOSE}" == "1" ]]; then
		echo "$@" >&2
	fi
}

log "mac-setup: verbose (Homebrew + bin/*.sh)"

if [[ "${MAC_SETUP_VERBOSE}" != "1" ]]; then
	# Keep Node-based tools quiet (Cursor CLI, etc.) unless explicitly verbose.
	export NODE_NO_WARNINGS=1
	if [[ -n "${NODE_OPTIONS:-}" ]]; then
		export NODE_OPTIONS="${NODE_OPTIONS} --no-deprecation"
	else
		export NODE_OPTIONS="--no-deprecation"
	fi
fi

brew_upgrade() {
	brew update
	brew upgrade
	brew upgrade --cask
	brew cleanup
	log "Upgrade complete."
}

if [[ "${1:-}" == "--upgrade" ]]; then
	brew_upgrade
	exit 0
fi

brew_install() {
	if [[ "${MAC_SETUP_VERBOSE}" == "1" ]]; then
		if ! brew list --formula "$1"; then
			log "brew install formula: $1"
			brew install "$1"
		fi
	else
		if ! brew list --formula "$1" >/dev/null 2>&1; then
			brew install "$1"
		fi
	fi
}

brew_install crane
brew_install direnv
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
brew_install openjdk@21
brew_install shfmt
brew_install skopeo
brew_install stern
brew_install terraform
brew_install uv
brew_install watch
brew_install yarn
brew_install yq

brew_install_cask() {
	if [[ "${MAC_SETUP_VERBOSE}" == "1" ]]; then
		if ! brew list --cask "$1"; then
			log "brew install --cask: $1"
			brew install --cask "$1"
		fi
	else
		if ! brew list --cask "$1" >/dev/null 2>&1; then
			brew install --cask "$1"
		fi
	fi
}

brew_install_cask alt-tab
brew_install_cask claude-code
brew_install_cask cursor
brew_install_cask devtoys
brew_install_cask docker
brew_install_cask espanso
brew_install_cask firefox
brew_install_cask font-hack-nerd-font
brew_install_cask gcloud-cli
brew_install_cask intellij-idea-ce
brew_install_cask iterm2
brew_install_cask lens
brew_install_cask logi-options+
brew_install_cask lulu
brew_install_cask postman
brew_install_cask raycast
brew_install_cask webstorm
brew_install_cask zed

for F in ${HOME}/Source/mac-setup/bin/*.sh; do
	log "source $(basename "$F")"
	source "$F"
done

echo "Install complete."
