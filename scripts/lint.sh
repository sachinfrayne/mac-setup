#!/usr/bin/env bash
#
# lint.sh - Run shellcheck on all shell scripts in the project
#
# Usage: ./scripts/lint.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Check if shellcheck is installed
if ! command -v shellcheck &>/dev/null; then
    echo "ERROR: shellcheck is not installed."
    echo "Install with: brew install shellcheck"
    exit 1
fi

echo "Running shellcheck on all .sh files..."

# Find all .sh files, excluding test fixtures
SHELLCHECK_FILES=()
while IFS= read -r -d '' file; do
    # Skip test fixtures and any files in hidden directories
    if [[ "$file" != *"/fixtures/"* && "$file" != */.*/* ]]; then
        SHELLCHECK_FILES+=("$file")
    fi
done < <(find "$PROJECT_ROOT" -type f -name "*.sh" -print0)

if [[ ${#SHELLCHECK_FILES[@]} -eq 0 ]]; then
    echo "No .sh files found to check."
    exit 0
fi

echo "Checking ${#SHELLCHECK_FILES[@]} files..."

# Run shellcheck with project configuration
ERROR_COUNT=0
for file in "${SHELLCHECK_FILES[@]}"; do
    if ! shellcheck --color=auto --external-sources --source-path=SCRIPTDIR "$file"; then
        ((ERROR_COUNT++))
    fi
done

echo ""
if [[ $ERROR_COUNT -eq 0 ]]; then
    echo "✓ All files passed shellcheck!"
    exit 0
else
    echo "✗ $ERROR_COUNT file(s) had shellcheck errors."
    exit 1
fi
