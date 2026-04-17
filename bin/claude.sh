#!/usr/bin/env bash
#
# Claude Code setup script
# Configures status line to show current directory and git branch
#

set -euo pipefail

# Uses `log` from setup.sh when sourced; no-op if run standalone without it.
if ! declare -F log >/dev/null 2>&1; then
	log() { :; }
fi

CLAUDE_DIR="$HOME/.claude"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
STATUSLINE_SCRIPT="$CLAUDE_DIR/statusline-command.sh"

# Create .claude directory if it doesn't exist
mkdir -p "$CLAUDE_DIR"

# Create or update settings.json with status line configuration
cat > "$SETTINGS_FILE" <<'EOF'
{
  "enabledPlugins": {
    "code-simplifier@claude-plugins-official": true
  },
  "statusLine": {
    "type": "command",
    "command": "__STATUSLINE_SCRIPT__"
  }
}
EOF

export STATUSLINE_SCRIPT
perl -0777 -i -pe 's|"__STATUSLINE_SCRIPT__"|"$ENV{STATUSLINE_SCRIPT}"|g' "$SETTINGS_FILE"

# Create status line script
cat > "$STATUSLINE_SCRIPT" <<'EOF'
#!/usr/bin/env bash

# Get current working directory
pwd_path=$(pwd)

# Get git branch if in a git repo
if git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git --no-optional-locks branch --show-current 2>/dev/null || echo "detached")
    git_info=" | git:$branch"
else
    git_info=""
fi

# Output status line
echo "${pwd_path}${git_info}"
EOF

# Make status line script executable
chmod +x "$STATUSLINE_SCRIPT"

log "Claude Code configured:"
log "  - settings: $SETTINGS_FILE"
log "  - statusline: $STATUSLINE_SCRIPT"
