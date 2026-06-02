#!/usr/bin/env bash

set -euo pipefail

# Source common utilities library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

MAC_SETUP_VERBOSE=0
DRY_RUN=0

# Parse flags (can be combined)
while [[ $# -gt 0 ]]; do
	case "$1" in
	--verbose | -v)
		MAC_SETUP_VERBOSE=1
		shift
		;;
	--dry-run)
		DRY_RUN=1
		shift
		;;
	--upgrade | --help | -h | --verify | --lint)
		# Don't shift these, handle them below
		break
		;;
	*)
		break
		;;
	esac
done

export MAC_SETUP_VERBOSE
export DRY_RUN

usage() {
	cat <<'EOF'
Usage: mac [--verbose|-v] [--dry-run] [--upgrade] [--verify] [--lint] [--help|-h]

Options:
  --verbose, -v   Print extra progress details (and unsuppress some output).
  --dry-run       Show what would be installed without making changes.
  --upgrade       Run Homebrew update/upgrade/cleanup and exit.
  --verify        Verify all installations and configurations.
  --lint          Run shellcheck on all shell scripts and exit.
  --help, -h      Show this help and exit.

Examples:
  mac                    # Run setup (idempotent)
  mac --verbose          # Run with detailed output
  mac --dry-run          # Preview what would be installed
  mac --upgrade          # Upgrade all Homebrew packages
  mac --verify           # Check installation status
  mac --lint             # Lint all shell scripts
EOF
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
	usage
	exit 0
fi

# log() function now provided by lib/common.sh

if [[ "${DRY_RUN}" == "1" ]]; then
	echo "DRY RUN MODE - No changes will be made"
	echo "============================================"
fi

log "mac-setup: verbose (Homebrew + bin/*.sh)"

# Verify Homebrew is installed (skip in dry-run mode)
if [[ "${DRY_RUN}" != "1" ]]; then
	if ! require_command brew "Homebrew is required. Install from https://brew.sh"; then
		exit 1
	fi
fi

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

if [[ "${1:-}" == "--verify" ]]; then
	if [[ -x "${MAC_SETUP_ROOT}/scripts/verify.sh" ]]; then
		exec "${MAC_SETUP_ROOT}/scripts/verify.sh"
	else
		echo "ERROR: Verification script not found at ${MAC_SETUP_ROOT}/scripts/verify.sh"
		exit 1
	fi
fi

if [[ "${1:-}" == "--lint" ]]; then
	if [[ -x "${MAC_SETUP_ROOT}/scripts/lint.sh" ]]; then
		exec "${MAC_SETUP_ROOT}/scripts/lint.sh"
	else
		echo "ERROR: Lint script not found at ${MAC_SETUP_ROOT}/scripts/lint.sh"
		exit 1
	fi
fi

# brew_install() function now provided by lib/common.sh

brew_install crane
brew_install direnv
brew_install docker-compose
brew_install gemini-cli
brew_install gh
brew_install gradle
brew_install helm
brew_install htop
brew_install imagemagick
brew_install jbang
brew_install jq
brew_install kcat
brew_install kubectl
brew_install kubectx
brew_install minikube
brew_install node
brew_install nvm
brew_install ollama
brew_install openjdk@21
brew_install shellcheck
brew_install shfmt
brew_install skopeo
brew_install stern
brew_install terraform
brew_install uv
brew_install watch
brew_install yarn
brew_install yq

# brew_install_cask() function now provided by lib/common.sh

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

if [[ "${DRY_RUN}" != "1" ]]; then
	for F in "${MAC_SETUP_ROOT}"/bin/*.sh; do
		log "source $(basename "$F")"
		# shellcheck source=/dev/null
		source "$F"
	done
	echo "Install complete."
else
	echo ""
	echo "============================================"
	echo "DRY RUN COMPLETE - No changes were made"
	echo "Run without --dry-run to actually install"
fi
