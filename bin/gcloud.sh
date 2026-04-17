#!/usr/bin/env bash

set -euo pipefail

# Source common utilities
if [[ -z "${MAC_SETUP_ROOT:-}" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # shellcheck source=../lib/common.sh
    source "${SCRIPT_DIR}/../lib/common.sh"
fi

# Check if gcloud is installed
if ! check_command_exists gcloud; then
    log "WARNING: gcloud is not installed. Skipping gcloud configuration."
    # shellcheck disable=SC2317
    return 0 2>/dev/null || exit 0
fi

# Warn if not authenticated (but continue)
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" 2>/dev/null | grep -q .; then
    log "WARNING: No active gcloud authentication found. Run 'gcloud auth login' to authenticate."
fi

if [[ "${MAC_SETUP_VERBOSE:-0}" == "1" ]]; then
	gcloud components install gke-gcloud-auth-plugin
else
	gcloud components install gke-gcloud-auth-plugin >/dev/null 2>&1
fi
