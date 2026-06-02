#!/usr/bin/env bash
#
# Cursor CLI bootstrap: PATH, Node deprecation noise, extensions, user snippets,
# settings, and keybindings. Safe to source from zshrc (uses return on failure).
#

set -euo pipefail

if [[ -z "${MAC_SETUP_ROOT:-}" ]]; then
	SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	source "${SCRIPT_DIR}/../lib/common.sh"
fi

if [[ "${MAC_SETUP_VERBOSE:-0}" != "1" ]]; then
	if [[ -n "${NODE_OPTIONS:-}" ]]; then
		export NODE_OPTIONS="${NODE_OPTIONS} --no-deprecation"
	else
		export NODE_OPTIONS="--no-deprecation"
	fi
fi

export PATH="/Applications/Cursor.app/Contents/Resources/app/bin:$PATH"

if ! command -v cursor &>/dev/null; then
	echo "Cursor CLI not found. Install the Cursor app (brew install --cask cursor)."
	return 1 2>/dev/null || exit 1
fi

mapfile -t EXTENSIONS < <(
	if [[ "${MAC_SETUP_VERBOSE:-0}" == "1" ]]; then
		cursor --list-extensions
	else
		NODE_OPTIONS="--no-deprecation" cursor --list-extensions
	fi | tr '[:upper:]' '[:lower:]'
)

cursor_install_extension() {
	local ext="$1" installed
	for installed in "${EXTENSIONS[@]}"; do
		[[ "$installed" == "$ext" ]] && return 0
	done
	if [[ "${MAC_SETUP_VERBOSE:-0}" == "1" ]]; then
		cursor --install-extension "$ext" || true
	else
		NODE_OPTIONS="--no-deprecation" cursor --install-extension "$ext" || true
	fi
}

CURSOR_EXTENSIONS=(
	hashicorp.terraform
	lucien-martijn.parquet-visualizer
	ms-python.python
	ms-vscode.makefile-tools
	redhat.java
	streetsidesoftware.code-spell-checker
	yzhang.markdown-all-in-one
)
for ext in "${CURSOR_EXTENSIONS[@]}"; do
	cursor_install_extension "$ext"
done

CURSOR_USER="${HOME}/Library/Application Support/Cursor/User"
mkdir -p "${CURSOR_USER}/snippets"

MAC_SETUP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." && pwd)"
WORKSPACE_ROOT="$(cd "${MAC_SETUP_ROOT}/.." && pwd)"
CURSOR_SKILLS_SRC="${WORKSPACE_ROOT}/.cursor/skills"
CURSOR_SKILLS_HOME="${HOME}/.cursor/skills"
mkdir -p "${CURSOR_SKILLS_SRC}"
if [[ -L "${CURSOR_SKILLS_HOME}" ]]; then
	current_target="$(readlink "${CURSOR_SKILLS_HOME}")"
	if [[ "${current_target}" != "${CURSOR_SKILLS_SRC}" ]]; then
		rm "${CURSOR_SKILLS_HOME}"
		ln -s "${CURSOR_SKILLS_SRC}" "${CURSOR_SKILLS_HOME}"
	fi
elif [[ -d "${CURSOR_SKILLS_HOME}" ]]; then
	shopt -s dotglob nullglob
	for item in "${CURSOR_SKILLS_HOME}"/*; do
		base="$(basename "${item}")"
		if [[ -e "${CURSOR_SKILLS_SRC}/${base}" ]]; then
			continue
		fi
		mv "${item}" "${CURSOR_SKILLS_SRC}/"
	done
	shopt -u dotglob nullglob
	rmdir "${CURSOR_SKILLS_HOME}" 2>/dev/null || rm -rf "${CURSOR_SKILLS_HOME}"
	ln -s "${CURSOR_SKILLS_SRC}" "${CURSOR_SKILLS_HOME}"
elif [[ ! -e "${CURSOR_SKILLS_HOME}" ]]; then
	ln -s "${CURSOR_SKILLS_SRC}" "${CURSOR_SKILLS_HOME}"
fi

WORDLIST="${CURSOR_USER}/cspell-user-words.txt"
touch "$WORDLIST"
if [[ ! -s "$WORDLIST" ]]; then
	printf '# One word per line; add entries here as needed.\n' >>"$WORDLIST"
fi

CURSOR_SEED_WORDS="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)/cursor/cspell-seed-words.txt"
if [[ ! -f "$CURSOR_SEED_WORDS" ]]; then
	echo "cursor.sh: seed words file not found: $CURSOR_SEED_WORDS" >&2
	# shellcheck disable=SC2317
	return 1 2>/dev/null || exit 1
fi
while IFS= read -r line || [[ -n "$line" ]]; do
	[[ -z "$line" || "$line" =~ ^# ]] && continue
	grep -qxF -- "$line" "$WORDLIST" 2>/dev/null || printf '%s\n' "$line" >>"$WORDLIST"
done <"$CURSOR_SEED_WORDS"

tee_out "${CURSOR_USER}/snippets/bash-file-header.code-snippets" <<'EOF'
{
  "Bash File Header": {
    "prefix": ["bash"],
    "body": ["#!/usr/bin/env bash"]
  }
}
EOF

tee_out "${CURSOR_USER}/settings.json" <<'EOF'
{
  "diffEditor.ignoreTrimWhitespace": false,
  "editor.formatOnSave": true,
  "editor.wordWrap": "on",
  "editor.rulers": [{ "column": 80, "color": "#5a5a5a80" }],
  "editor.tabSize": 2,
  "files.autoSave": "afterDelay",
  "terminal.integrated.fontFamily": "Hack Nerd Font",
  "workbench.colorTheme": "Default Dark+",
  "workbench.editorAssociations": {"*.csv": "default"},
  "cSpell.dictionaryDefinitions": [
    {
      "name": "cursor-user-words",
      "path": "${userHome}/Library/Application Support/Cursor/User/cspell-user-words.txt",
      "addWords": true
    }
  ],
  "cSpell.dictionaries": ["cursor-user-words"],
  "python.defaultInterpreterPath": "/opt/homebrew/bin/python3",
  "workbench.iconTheme": "vscode-icons",
  "[json]": {"editor.defaultFormatter": "esbenp.prettier-vscode"},
  "[terraform]": {"editor.defaultFormatter": "hashicorp.terraform"},
  "[yaml]": {"editor.defaultFormatter": "esbenp.prettier-vscode"},
  "[makefile]": {
    "editor.insertSpaces": false,
    "editor.detectIndentation": false,
    "editor.tabSize": 4
  },
  "[markdown]": {"editor.defaultFormatter": "esbenp.prettier-vscode"}
}
EOF

tee_out "${CURSOR_USER}/keybindings.json" <<'EOF'
[
  {
    "key": "shift+cmd+c",
    "command": "-workbench.action.terminal.openNativeConsole",
    "when": "!terminalFocus"
  },
  {
    "key": "shift+cmd+c",
    "command": "editor.action.toggleColumnSelection"
  },
  {
    "key": "shift+cmd+d",
    "command": "-workbench.view.debug",
    "when": "viewContainer.workbench.view.debug.enabled"
  },
  {
    "key": "shift+cmd+d",
    "command": "editor.action.duplicateSelection"
  }
]
EOF
