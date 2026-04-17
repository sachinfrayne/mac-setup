#!/usr/bin/env bash
#
# common.sh - Shared utilities for mac-setup
#
# This library provides common functions used across all mac-setup scripts.
# It should be sourced by setup.sh and all bin/*.sh scripts.
#

# Prevent double-sourcing
if [[ -n "${MAC_SETUP_COMMON_LOADED:-}" ]]; then
  return 0
fi
MAC_SETUP_COMMON_LOADED=1

#------------------------------------------------------------------------------
# Path Detection
#------------------------------------------------------------------------------

# Detect the root directory of mac-setup
# Works whether sourced from setup.sh or bin/*.sh
get_mac_setup_root() {
  local script_dir
  if [[ -n "${BASH_SOURCE[0]:-}" ]]; then
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  else
    script_dir="$(cd "$(dirname "$0")" && pwd)"
  fi

  # If we're in lib/, go up one level
  if [[ "$(basename "$script_dir")" == "lib" ]]; then
    (cd "$script_dir/.." && pwd)
  # If we're in bin/, go up one level
  elif [[ "$(basename "$script_dir")" == "bin" ]]; then
    (cd "$script_dir/.." && pwd)
  # Otherwise we're at the root
  else
    echo "$script_dir"
  fi
}

# Detect Homebrew installation prefix
# Supports both Apple Silicon (/opt/homebrew) and Intel (/usr/local)
detect_brew_prefix() {
  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    echo "/opt/homebrew"
  elif [[ -x "/usr/local/bin/brew" ]]; then
    echo "/usr/local"
  elif command -v brew &>/dev/null; then
    brew --prefix
  else
    echo ""
  fi
}

# Get system architecture
get_arch() {
  uname -m
}

# Check macOS version
check_macos_version() {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    return 1
  fi
  return 0
}

# Export key paths
export MAC_SETUP_ROOT="${MAC_SETUP_ROOT:-$(get_mac_setup_root)}"
export BREW_PREFIX="${BREW_PREFIX:-$(detect_brew_prefix)}"
export MAC_SETUP_ARCH="${MAC_SETUP_ARCH:-$(get_arch)}"

#------------------------------------------------------------------------------
# Command Validation
#------------------------------------------------------------------------------

# Check if a command exists
check_command_exists() {
  command -v "$1" &>/dev/null
}

# Require a command to be installed
# Usage: require_command <command> [error_message]
require_command() {
  local cmd="$1"
  local msg="${2:-Command \"$cmd\" is required but not found. Please install it first.}"

  if ! check_command_exists "$cmd"; then
    echo "ERROR: $msg" >&2
    return 1
  fi
  return 0
}

#------------------------------------------------------------------------------
# Logging and Output
#------------------------------------------------------------------------------

# Log a message if verbose mode is enabled
# Respects MAC_SETUP_VERBOSE environment variable
log() {
  if [[ "${MAC_SETUP_VERBOSE:-0}" == "1" ]]; then
    echo "$@" >&2
  fi
}

# Tee to a file, optionally silencing stdout unless verbose
# Usage: tee_out <file> [tee_args...]
tee_out() {
  if [[ "${MAC_SETUP_VERBOSE:-0}" == "1" ]]; then
    tee "$@"
  else
    tee "$@" >/dev/null
  fi
}

#------------------------------------------------------------------------------
# Git Operations
#------------------------------------------------------------------------------

# Clone a git repository or pull if it already exists
# Usage: git_clone <url> <destination>
git_clone() {
  local url="$1"
  local dest="$2"

  if [[ ! -d "$dest" ]]; then
    if [[ "${MAC_SETUP_VERBOSE:-0}" == "1" ]]; then
      git clone "$url" "$dest"
    else
      git clone "$url" "$dest" >/dev/null 2>&1
    fi
  else
    if [[ "${MAC_SETUP_VERBOSE:-0}" == "1" ]]; then
      (cd "$dest" && git pull)
    else
      (cd "$dest" && git pull >/dev/null 2>&1)
    fi
  fi
}

#------------------------------------------------------------------------------
# Python Detection
#------------------------------------------------------------------------------

# Find the latest Python 3 installation
# Returns the full path to python3.x binary
get_python3_path() {
  local brew_prefix="${BREW_PREFIX:-/opt/homebrew}"

  # First try to find the latest versioned python3 in Homebrew
  if [[ -d "${brew_prefix}/bin" ]]; then
    # Find all python3.x binaries and sort by version
    local latest
    latest=$(find "${brew_prefix}/bin" -name 'python3.*' -type f 2>/dev/null | \
             grep -E 'python3\.[0-9]+$' | \
             sort -V | \
             tail -n 1)

    if [[ -n "$latest" && -x "$latest" ]]; then
      echo "$latest"
      return 0
    fi
  fi

  # Fallback to generic python3
  if [[ -x "${brew_prefix}/bin/python3" ]]; then
    echo "${brew_prefix}/bin/python3"
    return 0
  fi

  # Last resort: use system python3
  if command -v python3 &>/dev/null; then
    command -v python3
    return 0
  fi

  echo ""
  return 1
}

#------------------------------------------------------------------------------
# Homebrew Operations
#------------------------------------------------------------------------------

# Install a Homebrew formula if not already installed
# Respects MAC_SETUP_VERBOSE and DRY_RUN environment variables
brew_install() {
  local formula="$1"

  # Dry run mode - always show output
  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    # In dry-run, don't call brew if it's not available
    if command -v brew &>/dev/null; then
      if ! brew list --formula "$formula" >/dev/null 2>&1; then
        echo "[WOULD INSTALL] formula: $formula"
      else
        echo "[SKIP] formula: $formula (already installed)"
      fi
    else
      echo "[WOULD INSTALL] formula: $formula (brew not available to check)"
    fi
    return 0
  fi

  # Normal installation
  if [[ "${MAC_SETUP_VERBOSE:-0}" == "1" ]]; then
    if ! brew list --formula "$formula" 2>&1; then
      log "brew install formula: $formula"
      brew install "$formula"
    fi
  else
    if ! brew list --formula "$formula" >/dev/null 2>&1; then
      brew install "$formula"
    fi
  fi
}

# Install a Homebrew cask if not already installed
# Respects MAC_SETUP_VERBOSE and DRY_RUN environment variables
brew_install_cask() {
  local cask="$1"

  # Dry run mode - always show output
  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    # In dry-run, don't call brew if it's not available
    if command -v brew &>/dev/null; then
      if ! brew list --cask "$cask" >/dev/null 2>&1; then
        echo "[WOULD INSTALL] cask: $cask"
      else
        echo "[SKIP] cask: $cask (already installed)"
      fi
    else
      echo "[WOULD INSTALL] cask: $cask (brew not available to check)"
    fi
    return 0
  fi

  # Normal installation
  if [[ "${MAC_SETUP_VERBOSE:-0}" == "1" ]]; then
    if ! brew list --cask "$cask" 2>&1; then
      log "brew install --cask: $cask"
      brew install --cask "$cask"
    fi
  else
    if ! brew list --cask "$cask" >/dev/null 2>&1; then
      brew install --cask "$cask"
    fi
  fi
}

#------------------------------------------------------------------------------
# End of common.sh
#------------------------------------------------------------------------------
