#!/usr/bin/env bash

tee_out() {
	if [[ "${MAC_SETUP_VERBOSE:-0}" == "1" ]]; then
		tee "$@"
	else
		tee "$@" >/dev/null
	fi
}

mkdir -p ${HOME}/Library/Application\ Support/espanso/match/packages/
mkdir -p ${HOME}/Library/Application\ Support/espanso/config/

cp -f ${HOME}/Source/mac-setup/bin/espanso/*.yml ${HOME}/Library/Application\ Support/espanso/match/packages/

tee_out ${HOME}/Library/Application\ Support/espanso/match/base.yml <<-'EOF'
	matches:
	  - trigger: ":espanso"
	    replace: "Hi there!"
EOF

tee_out ${HOME}/Library/Application\ Support/espanso/config/default.yml <<-'EOF'
	search_shortcut: off
EOF
