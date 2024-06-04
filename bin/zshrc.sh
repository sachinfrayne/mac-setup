#!/usr/bin/env bash

tee ${HOME}/.zshrc <<-'EOF' >/dev/null
ZSH_THEME=""

HISTFILE=${HOME}/.zsh_history
HISTSIZE=9999999
SAVEHIST=9999999

setopt EXTENDED_HISTORY
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/"

source ${HOME}/.zsh/custom/plugins/powerlevel10k/powerlevel10k.zsh-theme
source ${HOME}/.zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ${HOME}/.zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

autoload -U +X compinit && compinit
source <(kubectl completion zsh)
POWERLEVEL9K_MODE=nerdfont-complete
POWERLEVEL9K_CUSTOM_PROMPT_BACKGROUND="black"
POWERLEVEL9K_CUSTOM_PROMPT_FOREGROUND="white"
POWERLEVEL9K_CUSTOM_PROMPT="echo $"
POWERLEVEL9K_DIR_FOREGROUND="white"
POWERLEVEL9K_DISABLE_RPROMPT=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs custom_prompt)
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

alias brew_upgrade='brew outdated | xargs brew reinstall'
alias c='clear'
alias clear='printf "\033c"'
alias cp='cp -iv'
alias docker_clean='docker container rm $(docker container ls -a -q) || true; docker network prune -f; docker volume prune -f'
alias docker_start='open -a Docker'
alias docker_stop='pkill -SIGHUP -f /Applications/Docker.app "docker serve"'
alias finder='open .'
alias grep='grep --color=auto'
alias history='history -in'
alias hgrep='history -in 0|grep'
alias k=kubectl
alias ll='ls -lah'
alias ls='ls -G'
alias mac='${HOME}/Source/mac-setup/mac.sh'
alias mkdir='mkdir -pv'
alias mv='mv -iv'
alias python='/opt/homebrew/bin/python3'
alias reset_coreaudio='sudo killall coreaudiod'
alias tailf='tail -f'

function cheat () {
  curl "https://cheat.sh/$1?style=default"
}

EOF
