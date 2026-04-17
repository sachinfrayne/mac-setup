#!/usr/bin/env bash

set -euo pipefail

# Source common utilities
if [[ -z "${MAC_SETUP_ROOT:-}" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # shellcheck source=../lib/common.sh
    source "${SCRIPT_DIR}/../lib/common.sh"
fi

# tee_out() function provided by lib/common.sh

# Verify source directory exists
if [[ ! -d "${MAC_SETUP_ROOT}/bin/espanso" ]]; then
    log "WARNING: espanso configuration directory not found at ${MAC_SETUP_ROOT}/bin/espanso"
    log "Skipping espanso .yml file copy."
fi

mkdir -p "${HOME}/Library/Application Support/espanso/match/packages/"
mkdir -p "${HOME}/Library/Application Support/espanso/config/"

# Only copy if source directory exists and has .yml files
if [[ -d "${MAC_SETUP_ROOT}/bin/espanso" ]] && compgen -G "${MAC_SETUP_ROOT}/bin/espanso/*.yml" > /dev/null; then
    cp -f "${MAC_SETUP_ROOT}/bin/espanso/"*.yml "${HOME}/Library/Application Support/espanso/match/packages/"
fi

tee_out "${HOME}/Library/Application Support/espanso/match/base.yml" <<-'EOF'
	matches:
	  - trigger: ":espanso"
	    replace: "Hi there!"
EOF

tee_out "${HOME}/Library/Application Support/espanso/config/default.yml" <<-'EOF'
	search_shortcut: off
EOF
