#!/usr/bin/env bash

set -euo pipefail

if [[ -z "${MAC_SETUP_ROOT:-}" ]]; then
	MAC_SETUP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi
# shellcheck source=../lib/common.sh
source "${MAC_SETUP_ROOT}/lib/common.sh"

ZSHRC_DIR="${MAC_SETUP_ROOT}/bin/zshrc"
ALIASES_AND_FUNCTIONS_FILE="${ZSHRC_DIR}/aliases_and_functions.sh"

# shellcheck source=zshrc/ensure_command_descriptions.sh
source "${ZSHRC_DIR}/ensure_command_descriptions.sh"
ensure_command_descriptions "${ALIASES_AND_FUNCTIONS_FILE}"

mkdir -p "${HOME}/.zsh/custom"
sed \
	-e "s|__MAC_SETUP_ROOT__|${MAC_SETUP_ROOT}|g" \
	-e "s|__DETECTED_PYTHON_PATH__|$(get_python3_path)|g" \
	"${ALIASES_AND_FUNCTIONS_FILE}" >"${HOME}/.zsh/custom/commands.zsh"

# Generate .zshrc with dynamic paths
# Note: Using non-quoted EOF to allow variable expansion
cat >"${HOME}/.zshrc" <<EOF
ZSH_THEME=""

HISTFILE=\${HOME}/.zsh_history
HISTSIZE=9999999
SAVEHIST=9999999

eval "\$(${BREW_PREFIX}/bin/brew shellenv)"

setopt EXTENDED_HISTORY
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# NODE
export NODE_OPTIONS="--no-deprecation"

# DOCKER
export PATH="\$PATH:/Applications/Docker.app/Contents/Resources/bin/"

# JAVA (Homebrew OpenJDK 21; no sudo symlink into /Library/Java)
export JAVA_HOME="${BREW_PREFIX}/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
export PATH="\$JAVA_HOME/bin:\$PATH"

# CURSOR CLI (no sudo symlink into /usr/local/bin)
export PATH="/Applications/Cursor.app/Contents/Resources/app/bin:\$PATH"

# NVM
export NVM_DIR="\$HOME/.nvm"
[ -s "${BREW_PREFIX}/opt/nvm/nvm.sh" ] && \\. "${BREW_PREFIX}/opt/nvm/nvm.sh"
[ -s "${BREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm" ] && \\. "${BREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm"

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
