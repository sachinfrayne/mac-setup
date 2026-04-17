#!/usr/bin/env bash

set -euo pipefail

# Source common utilities
if [[ -z "${MAC_SETUP_ROOT:-}" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # shellcheck source=../lib/common.sh
    source "${SCRIPT_DIR}/../lib/common.sh"
fi

# tee_out() function provided by lib/common.sh

mkdir -p "${HOME}/.config/zed"
tee_out "${HOME}/.config/zed/settings.json" <<-'EOF'
{
  "ui_font_size": 16,
  "buffer_font_size": 16,
  "theme": {
    "mode": "system",
    "light": "One Light",
    "dark": "One Dark"
  },
  "languages": {
    "Markdown": {
      "format_on_save": "on"
    }
  }
}
EOF
