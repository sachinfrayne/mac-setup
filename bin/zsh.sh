#!/usr/bin/env bash

function git_clone() {
  if [[ ! -d $2 ]]; then
    git clone $1 $2
  else
    if [[ "${MAC_SETUP_VERBOSE:-0}" == "1" ]]; then
      (cd $2 && git pull)
    else
      (cd $2 && git pull >/dev/null 2>&1)
    fi
  fi
}

git_clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/.zsh/custom/plugins/zsh-syntax-highlighting
git_clone https://github.com/zsh-users/zsh-autosuggestions ${HOME}/.zsh/custom/plugins/zsh-autosuggestions
git_clone https://github.com/romkatv/powerlevel10k.git ${HOME}/.zsh/custom/plugins/powerlevel10k
