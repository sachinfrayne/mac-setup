#!/usr/bin/env bash
#
# test-backups.sh - Check that existing config files are backed up, never lost
#
# Runs the config writers against a throwaway HOME, so your real dotfiles
# are never touched. Exits non-zero on the first failure.
#

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_HOME="$(mktemp -d)"
trap 'rm -rf "${TMP_HOME}"' EXIT

fail() { echo "FAIL: $*" >&2; exit 1; }
pass() { echo "PASS: $*"; }

mkdir -p "${TMP_HOME}/.claude"
echo "ORIGINAL-ZSHRC" > "${TMP_HOME}/.zshrc"
echo '{"mine": true}' > "${TMP_HOME}/.claude/settings.json"
echo "old-statusline" > "${TMP_HOME}/.claude/statusline-command.sh"

# 1. Two writes to the same file in one second must keep both backups and the original.
(
  export HOME="${TMP_HOME}" MAC_SETUP_ROOT="${ROOT}"
  # shellcheck source=../lib/common.sh
  source "${ROOT}/lib/common.sh"
  printf 'first\n' | tee_out "${HOME}/.zshrc" >/dev/null
  printf 'second\n' | tee_out "${HOME}/.zshrc" >/dev/null
)
grep -q "^ORIGINAL-ZSHRC$" "${TMP_HOME}"/.zshrc.bak.* || fail "original ~/.zshrc was not backed up"
[[ "$(ls "${TMP_HOME}"/.zshrc.bak.* | wc -l | tr -d ' ')" == "2" ]] || fail "expected two backups from two writes"
pass "tee_out keeps the original and every earlier version"

# 2. zshrc.sh and claude.sh back up the files they rewrite.
(export HOME="${TMP_HOME}" MAC_SETUP_ROOT="${ROOT}"; bash "${ROOT}/bin/zshrc.sh" >/dev/null 2>&1) || fail "zshrc.sh failed"
grep -q "^ORIGINAL-ZSHRC$" "${TMP_HOME}"/.zshrc.bak.* || fail "original survived zshrc.sh"
pass "zshrc.sh backs up ~/.zshrc before rewriting it"

(export HOME="${TMP_HOME}" MAC_SETUP_ROOT="${ROOT}"; bash "${ROOT}/bin/claude.sh" >/dev/null 2>&1) || fail "claude.sh failed"
grep -l '"mine": true' "${TMP_HOME}"/.claude/settings.json.bak.* >/dev/null 2>&1 || fail "original settings.json was not backed up"
grep -l "old-statusline" "${TMP_HOME}"/.claude/statusline-command.sh.bak.* >/dev/null 2>&1 || fail "original status line script was not backed up"
pass "claude.sh backs up settings.json and the status line script"

echo "All backup checks passed."
