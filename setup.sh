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

brew_install crane          # copy and inspect container images without a Docker daemon
brew_install direnv         # load per-project environment variables from .envrc files
brew_install docker-compose # define and run multi-container apps from compose.yaml
brew_install fzf            # fuzzy finder for files, history, git branches, and more
brew_install gemini-cli     # Google Gemini AI assistant in the terminal
brew_install gh             # GitHub CLI for PRs, issues, repos, and Actions
brew_install helm           # package manager for installing Kubernetes applications
brew_install htop           # interactive process and resource monitor
brew_install httpie         # friendly HTTP client for API testing from the CLI
brew_install jq             # query, filter, and transform JSON in shell pipelines
brew_install k9s            # terminal UI for browsing and managing Kubernetes clusters
brew_install kubectl        # official CLI for controlling Kubernetes clusters
brew_install kubectx        # fast switching between Kubernetes contexts and namespaces
brew_install minikube       # run a local single-node Kubernetes cluster for development
brew_install mkcert         # create locally trusted HTTPS certificates for localhost dev
brew_install node           # Node.js runtime for JavaScript and TypeScript tooling
brew_install nvm            # manage and switch between multiple Node.js versions
brew_install ollama         # run local large language models on your machine
brew_install openjdk@21     # Java 21 development kit for JVM-based projects
brew_install ripgrep        # fast recursive code and text search (rg)
brew_install shellcheck     # static analysis and linting for shell scripts
brew_install shfmt          # auto-format shell scripts for consistent style
brew_install skopeo         # inspect, copy, and sign container images across registries
brew_install stern          # tail logs from multiple Kubernetes pods at once
brew_install terraform      # infrastructure as code for cloud and Kubernetes resources
brew_install uv             # fast Python package and project manager
brew_install watch          # re-run a command on an interval to monitor output
brew_install yq             # query and edit YAML like jq does for JSON

# brew_install_cask() function now provided by lib/common.sh

brew_install_cask alt-tab             # Windows-style window switcher showing all app windows
brew_install_cask claude-code         # Anthropic AI coding agent for the terminal
brew_install_cask cursor              # AI-native code editor based on VS Code
brew_install_cask docker              # Docker Desktop for running and managing containers
brew_install_cask espanso             # system-wide text expander for snippets and shortcuts
brew_install_cask font-hack-nerd-font # Hack font with icon glyphs for terminal prompts
brew_install_cask gcloud-cli          # Google Cloud SDK for GCP auth, deploy, and storage
brew_install_cask google-chrome       # Chrome browser for DevTools, testing, and extensions
brew_install_cask iterm2              # feature-rich terminal emulator with splits and profiles
brew_install_cask lens                # GUI for browsing and managing Kubernetes clusters
brew_install_cask logi-options+       # configure Logitech mice and keyboards
brew_install_cask lulu                # outbound firewall that alerts on network connections
brew_install_cask postman             # GUI client for testing REST and other HTTP APIs
brew_install_cask raycast             # launcher and productivity hub replacing Spotlight
brew_install_cask tableplus           # GUI for querying Postgres, MySQL, Redis, and other databases
brew_install_cask zed                 # fast Rust-based code editor with collaborative features

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
