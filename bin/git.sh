#!/usr/bin/env bash

set -euo pipefail

# Source common utilities
if [[ -z "${MAC_SETUP_ROOT:-}" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # shellcheck source=../lib/common.sh
    source "${SCRIPT_DIR}/../lib/common.sh"
fi

git config --global user.email "sachin.frayne@gmail.com"
git config --global user.name "sachinfrayne"
git config --global credential.helper osxkeychain
git config --global pull.rebase true
