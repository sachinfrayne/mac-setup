# Custom zsh commands: public aliases and private helpers.
# Each public alias has a companion "<name>:desc" alias for shell-help.

# Paths for __mac and __python (placeholders expanded by bin/zshrc.sh at install)
export MAC_SETUP_ROOT="__MAC_SETUP_ROOT__"
export DETECTED_PYTHON_PATH="__DETECTED_PYTHON_PATH__"

__brew_upgrade() {
	brew update
	brew upgrade
	brew upgrade --cask
	brew cleanup
}

__cheat() {
	curl "https://cheat.sh/$1?style=default"
}

__mac() {
	"${MAC_SETUP_ROOT}/setup.sh" "$@"
}

__podman_clean() {
	read "REPLY?Remove all Podman containers and prune networks/volumes? [y/N] "
	if [[ "$REPLY" =~ ^[Yy]$ ]]; then
		podman container rm "$(podman container ls -a -q)" 2>/dev/null
		podman network prune -f
		podman volume prune -f
	fi
}

__podman_stop() {
	podman machine stop 2>/dev/null
	osascript -e 'quit app "Podman Desktop"' 2>/dev/null
}

__python() {
	"${DETECTED_PYTHON_PATH}" "$@"
}

# descriptions
alias brew_upgrade:desc='Update, upgrade, and clean up Homebrew formulae and casks'
alias cheat:desc='Show a cheat sheet from cheat.sh for a command'
alias clear:desc='Full terminal reset (clear scrollback)'
alias cp:desc='Copy files interactively and verbosely'
alias finder:desc='Open the current directory in Finder'
alias grep:desc='Grep with color highlighting'
alias hgrep:desc='Search shell history for a pattern'
alias history:desc='Show numbered shell history'
alias json:desc='Pretty-print JSON from stdin or a file'
alias k:desc='kubectl shorthand'
alias ll:desc='List all files in long format'
alias ls:desc='List files with color'
alias mac:desc='Run mac-setup'
alias mkdir:desc='Create directories with parents and verbose output'
alias mv:desc='Move files interactively and verbosely'
alias myip:desc='Show your public IP address'
alias please:desc='Alias for sudo'
alias podman_clean:desc='Remove all containers and prune networks and volumes (with confirmation)'
alias podman_stop:desc='Stop the Podman machine and quit Podman Desktop'
alias ports:desc='List processes listening on TCP ports'
alias python:desc='Use Homebrew Python 3'
alias reload:desc='Reload the zsh configuration from ~/.zshrc'
alias reset_coreaudio:desc='Restart macOS Core Audio'
alias yaml:desc='Pretty-print YAML, or convert YAML/JSON at the CLI'

# aliases
alias brew_upgrade='__brew_upgrade'
alias cheat='__cheat'
alias clear='printf "\033c"'
alias cp='cp -iv'
alias finder='open .'
alias grep='grep --color=auto'
alias hgrep='builtin history -in 0 | grep'
alias history='builtin history -in'
alias json='jq .'
alias k='kubectl'
alias ll='ls -lah'
alias ls='ls -G'
alias mac='__mac'
alias mkdir='mkdir -pv'
alias mv='mv -iv'
alias myip='curl -fsS ifconfig.me; echo'
alias please='sudo'
alias podman_clean='__podman_clean'
alias podman_stop='__podman_stop'
alias ports='lsof -nP -iTCP -sTCP:LISTEN'
alias python='__python'
alias reload='source ~/.zshrc'
alias reset_coreaudio='sudo killall coreaudiod'
alias yaml='yq eval -P'
