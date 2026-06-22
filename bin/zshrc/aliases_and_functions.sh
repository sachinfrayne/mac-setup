# Custom zsh commands.
# Each public alias has a companion "<name>:desc" alias for shell-help.

__cheat() {
	curl "https://cheat.sh/$1?style=default"
}

__git_reset_to_upstream() {
	local branch reply
	branch=$(git rev-parse --abbrev-ref HEAD) || return 1
	git fetch upstream || return 1
	printf 'Reset %s to upstream/%s? [y/N] ' "$branch" "$branch"
	read -r reply
	case "$reply" in
	[yY] | [yY][eE][sS]) ;;
	*)
		echo "Aborted."
		return 1
		;;
	esac
	git reset --hard "upstream/$branch"
}

# descriptions
alias brew_upgrade:desc='Reinstall outdated Homebrew formulae'
alias cheat:desc='Show a cheat sheet from cheat.sh for a command'
alias clear:desc='Full terminal reset (clear scrollback)'
alias cp:desc='Copy files interactively and verbosely'
alias docker_clean:desc='Remove all containers and prune networks and volumes'
alias docker_start:desc='Open Docker Desktop'
alias docker_stop:desc='Stop the Docker Desktop daemon'
alias finder:desc='Open the current directory in Finder'
alias git-reset-to-upstream:desc='Fetch upstream and hard-reset the current branch after confirmation'
alias grep:desc='Grep with color highlighting'
alias hgrep:desc='Search shell history for a pattern'
alias history:desc='Show numbered shell history'
alias k:desc='kubectl shorthand'
alias ll:desc='List all files in long format'
alias ls:desc='List files with color'
alias mac:desc='Run mac-setup'
alias mkdir:desc='Create directories with parents and verbose output'
alias mv:desc='Move files interactively and verbosely'
alias python:desc='Use Homebrew Python 3'
alias reset_coreaudio:desc='Restart macOS Core Audio'
alias tailf:desc='Follow a file'

# aliases
alias brew_upgrade='brew outdated | xargs brew reinstall'
alias cheat='__cheat'
alias clear='printf "\033c"'
alias cp='cp -iv'
alias docker_clean='docker container rm $(docker container ls -a -q) || true; docker network prune -f; docker volume prune -f'
alias docker_start='open -a Docker'
alias docker_stop='pkill -SIGHUP -f /Applications/Docker.app "docker serve"'
alias finder='open .'
alias git-reset-to-upstream='__git_reset_to_upstream'
alias grep='grep --color=auto'
alias hgrep='builtin history -in 0 | grep'
alias history='builtin history -in'
alias k='kubectl'
alias ll='ls -lah'
alias ls='ls -G'
alias mac='${MAC_SETUP_ROOT}/setup.sh'
alias mkdir='mkdir -pv'
alias mv='mv -iv'
alias python='${DETECTED_PYTHON_PATH}'
alias reset_coreaudio='sudo killall coreaudiod'
alias tailf='tail -f'
