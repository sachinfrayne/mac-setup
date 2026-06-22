#!/usr/bin/env bash

set -euo pipefail

# Source common utilities
if [[ -z "${MAC_SETUP_ROOT:-}" ]]; then
	MAC_SETUP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi
# shellcheck source=../lib/common.sh
source "${MAC_SETUP_ROOT}/lib/common.sh"

ZSHRC_BIN_DIR="${MAC_SETUP_ROOT}/bin"
ALIASES_AND_FUNCTIONS_FILE="${ZSHRC_BIN_DIR}/zshrc/aliases_and_functions.sh"
DETECTED_BREW_PREFIX="${BREW_PREFIX}"
DETECTED_PYTHON_PATH="$(get_python3_path)"

ensure_command_descriptions() {
	local file="$1"
	local -a missing=()
	local name line desc_marker="# descriptions"

	[[ -f "$file" ]] || return 0

	while IFS= read -r line; do
		[[ "$line" =~ ^alias[[:space:]]+([^=]+)= ]] || continue
		name="${BASH_REMATCH[1]}"
		[[ "$name" == *:desc ]] && continue
		if ! grep -qF "alias ${name}:desc=" "$file"; then
			missing+=("$name")
		fi
	done <"$file"

	(( ${#missing[@]} == 0 )) && return 0

	if grep -q "^${desc_marker}$" "$file"; then
		{
			while IFS= read -r line; do
				printf '%s\n' "$line"
				if [[ "$line" == "${desc_marker}" ]]; then
					for name in "${missing[@]}"; do
						printf "alias %s:desc='(no description)'\n" "$name"
					done
				fi
			done <"$file"
		} >"${file}.tmp"
	else
		{
			cat "$file"
			printf '\n%s\n' "$desc_marker"
			for name in "${missing[@]}"; do
				printf "alias %s:desc='(no description)'\n" "$name"
			done
		} >"${file}.tmp"
	fi
	mv "${file}.tmp" "$file"

	log "Added :desc aliases for: ${missing[*]}"
}

ensure_command_descriptions "${ALIASES_AND_FUNCTIONS_FILE}"

mkdir -p "${HOME}/.zsh/custom"
cp "${ALIASES_AND_FUNCTIONS_FILE}" "${HOME}/.zsh/custom/commands.zsh"

# Generate .zshrc with dynamic paths
# Note: Using non-quoted EOF to allow variable expansion
cat >"${HOME}/.zshrc" <<EOF
ZSH_THEME=""

HISTFILE=\${HOME}/.zsh_history
HISTSIZE=9999999
SAVEHIST=9999999

eval "\$(${DETECTED_BREW_PREFIX}/bin/brew shellenv)"

setopt EXTENDED_HISTORY
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# NODE
export NODE_OPTIONS="--no-deprecation"

# DOCKER
export PATH="\$PATH:/Applications/Docker.app/Contents/Resources/bin/"

# JAVA (Homebrew OpenJDK 21; no sudo symlink into /Library/Java)
export JAVA_HOME="${DETECTED_BREW_PREFIX}/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
export PATH="\$JAVA_HOME/bin:\$PATH"

# CURSOR CLI (no sudo symlink into /usr/local/bin)
export PATH="/Applications/Cursor.app/Contents/Resources/app/bin:\$PATH"

# NVM
export NVM_DIR="\$HOME/.nvm"
[ -s "${DETECTED_BREW_PREFIX}/opt/nvm/nvm.sh" ] && \\. "${DETECTED_BREW_PREFIX}/opt/nvm/nvm.sh"
[ -s "${DETECTED_BREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm" ] && \\. "${DETECTED_BREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm"

source \${HOME}/.zsh/custom/plugins/powerlevel10k/powerlevel10k.zsh-theme
source \${HOME}/.zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source \${HOME}/.zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

autoload -U +X compinit && compinit
source <(kubectl completion zsh)

# DIRENV (for per-directory environment variables)
eval "\$(direnv hook zsh)"
POWERLEVEL9K_MODE=nerdfont-complete
POWERLEVEL9K_CUSTOM_PROMPT_BACKGROUND="black"
POWERLEVEL9K_CUSTOM_PROMPT_FOREGROUND="white"
POWERLEVEL9K_CUSTOM_PROMPT="echo $"
POWERLEVEL9K_DIR_FOREGROUND="white"
POWERLEVEL9K_DISABLE_RPROMPT=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(custom_prompt)
POWERLEVEL9K_OS_ICON_FOREGROUND="green"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=green,green
ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,green
ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=green,green
ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=green,green
ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=green,green
ZSH_HIGHLIGHT_STYLES[globbing]=fg=red,bold
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=red,bold
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=red,bold

unalias -a

export MAC_SETUP_ROOT="${MAC_SETUP_ROOT}"
DETECTED_PYTHON_PATH="${DETECTED_PYTHON_PATH}"
[[ -f \${HOME}/.zsh/custom/commands.zsh ]] && source \${HOME}/.zsh/custom/commands.zsh

shell-help() {
  echo "# aliases"
  local name desc_key
  for name in \${(ko)aliases}; do
    [[ \$name == *:desc ]] && continue
    desc_key="\${name}:desc"
    if (( \$+aliases[\$desc_key] )); then
      printf '  %-28s %s\n' "\$name" "\${aliases[\$desc_key]}"
    else
      printf '  %-28s %s\n' "\$name" "(no description)"
    fi
  done
}

alias() {
  if (( \$# == 0 )); then
    shell-help
  else
    builtin alias "\$@"
  fi
}

[[ -f \${HOME}/.zsh/.zlocal ]] && source \${HOME}/.zsh/.zlocal

EOF
