#!/usr/bin/env bash

set -euo pipefail

# Source common utilities
if [[ -z "${MAC_SETUP_ROOT:-}" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # shellcheck source=../lib/common.sh
    source "${SCRIPT_DIR}/../lib/common.sh"
fi

# Check if git is installed
if ! require_command git "git is required to clone ZSH plugins. Install via 'xcode-select --install'"; then
    # shellcheck disable=SC2317
    return 1 2>/dev/null || exit 1
fi

# git_clone() function provided by lib/common.sh

git_clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.zsh/custom/plugins/zsh-syntax-highlighting"
git_clone https://github.com/zsh-users/zsh-autosuggestions "${HOME}/.zsh/custom/plugins/zsh-autosuggestions"
git_clone https://github.com/romkatv/powerlevel10k.git "${HOME}/.zsh/custom/plugins/powerlevel10k"
