#!/usr/bin/env bash

set -euo pipefail

# Source common utilities
if [[ -z "${MAC_SETUP_ROOT:-}" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # shellcheck source=../lib/common.sh
    source "${SCRIPT_DIR}/../lib/common.sh"
fi
# shellcheck source=../lib/packages.sh
source "${MAC_SETUP_ROOT}/lib/packages.sh"

# PYTHON_PACKAGES (single source of truth, shared with scripts/verify.sh) now
# provided by lib/packages.sh

if ! check_command_exists uv; then
    log "WARNING: uv is not installed. Skipping Python package installation."
    # shellcheck disable=SC2317
    return 0 2>/dev/null || exit 0
fi

PYTHON_BIN="$(get_python3_path)"

for entry in "${PYTHON_PACKAGES[@]}"; do
    pkg="$(pkg_name "$entry")"
    import_name="$(pkg_desc "$entry")"

    if [[ "${DRY_RUN:-0}" == "1" ]]; then
        if "${PYTHON_BIN}" -c "import ${import_name}" &>/dev/null; then
            echo "[SKIP] python package: ${pkg} (already installed)"
        else
            echo "[WOULD INSTALL] python package: ${pkg} (via uv)"
        fi
        continue
    fi

    if ! "${PYTHON_BIN}" -c "import ${import_name}" &>/dev/null; then
        # Homebrew's Python is externally managed (PEP 668); uv needs an
        # explicit opt-out to install packages into it directly, since these
        # are shared ad-hoc-script dependencies rather than a project venv.
        if [[ "${MAC_SETUP_VERBOSE:-0}" == "1" ]]; then
            uv pip install --system --break-system-packages --python "${PYTHON_BIN}" "${pkg}"
        else
            uv pip install --system --break-system-packages --python "${PYTHON_BIN}" "${pkg}" >/dev/null 2>&1
        fi
    fi
done
