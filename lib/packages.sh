#!/usr/bin/env bash
#
# packages.sh - Single source of truth for Homebrew packages
#
# This is the canonical list of formulae and casks that mac-setup installs.
# Both setup.sh (to install) and scripts/verify.sh (to verify) consume it,
# so the two stay in sync automatically.
#
# Each entry is "name|short description". Use pkg_name / pkg_desc to read them.
#

# Prevent double-sourcing
if [[ -n "${MAC_SETUP_PACKAGES_LOADED:-}" ]]; then
  return 0
fi
MAC_SETUP_PACKAGES_LOADED=1

# Extract the package name (everything before the first "|")
pkg_name() {
  echo "${1%%|*}"
}

# Extract the human-readable description (everything after the first "|")
pkg_desc() {
  echo "${1#*|}"
}

# Homebrew formulae (CLI tools)
BREW_FORMULAE=(
  "crane|copy and inspect container images without a Docker daemon"
  "direnv|load per-project environment variables from .envrc files"
  "docker-compose|define and run multi-container apps from compose.yaml"
  "fzf|fuzzy finder for files, history, git branches, and more"
  "gemini-cli|Google Gemini AI assistant in the terminal"
  "gh|GitHub CLI for PRs, issues, repos, and Actions"
  "helm|package manager for installing Kubernetes applications"
  "htop|interactive process and resource monitor"
  "httpie|friendly HTTP client for API testing from the CLI"
  "jq|query, filter, and transform JSON in shell pipelines"
  "k9s|terminal UI for browsing and managing Kubernetes clusters"
  "kubectl|official CLI for controlling Kubernetes clusters"
  "kubectx|fast switching between Kubernetes contexts and namespaces"
  "minikube|run a local single-node Kubernetes cluster for development"
  "mkcert|create locally trusted HTTPS certificates for localhost dev"
  "node|Node.js runtime for JavaScript and TypeScript tooling"
  "nvm|manage and switch between multiple Node.js versions"
  "ollama|run local large language models on your machine"
  "openjdk@21|Java 21 development kit for JVM-based projects"
  "opentofu|open-source Terraform fork (tofu) for infrastructure as code"
  "ripgrep|fast recursive code and text search (rg)"
  "shellcheck|static analysis and linting for shell scripts"
  "shfmt|auto-format shell scripts for consistent style"
  "skopeo|inspect, copy, and sign container images across registries"
  "stern|tail logs from multiple Kubernetes pods at once"
  "uv|fast Python package and project manager"
  "watch|re-run a command on an interval to monitor output"
  "yq|query and edit YAML like jq does for JSON"
)

# Homebrew casks (GUI apps, fonts, etc.)
BREW_CASKS=(
  "alt-tab|Windows-style window switcher showing all app windows"
  "claude-code|Anthropic AI coding agent for the terminal"
  "cursor|AI-native code editor based on VS Code"
  "docker|Docker Desktop for running and managing containers"
  "espanso|system-wide text expander for snippets and shortcuts"
  "font-hack-nerd-font|Hack font with icon glyphs for terminal prompts"
  "gcloud-cli|Google Cloud SDK for GCP auth, deploy, and storage"
  "iterm2|feature-rich terminal emulator with splits and profiles"
  "lens|GUI for browsing and managing Kubernetes clusters"
  "logi-options+|configure Logitech mice and keyboards"
  "lulu|outbound firewall that alerts on network connections"
  "postman|GUI client for testing REST and other HTTP APIs"
  "raycast|launcher and productivity hub replacing Spotlight"
  "slack|chat and messaging app for team collaboration"
  "tableplus|GUI for querying Postgres, MySQL, Redis, and other databases"
  "zed|fast Rust-based code editor with collaborative features"
)
