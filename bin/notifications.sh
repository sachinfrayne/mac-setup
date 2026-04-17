#!/usr/bin/env bash

set -euo pipefail

# Source common utilities
if [[ -z "${MAC_SETUP_ROOT:-}" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # shellcheck source=../lib/common.sh
    source "${SCRIPT_DIR}/../lib/common.sh"
fi

# Verify this is macOS
if ! check_macos_version; then
    log "WARNING: This script is only for macOS. Skipping notifications configuration."
    # shellcheck disable=SC2317
    return 0 2>/dev/null || exit 0
fi

# Verify defaults command exists
if ! check_command_exists defaults; then
    log "WARNING: defaults command not found. Skipping notifications configuration."
    # shellcheck disable=SC2317
    return 0 2>/dev/null || exit 0
fi

defaults write com.apple.notificationcenterui bannerTime 15
