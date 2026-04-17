#!/usr/bin/env bash

tee_out() {
	if [[ "${MAC_SETUP_VERBOSE:-0}" == "1" ]]; then
		tee "$@"
	else
		tee "$@" >/dev/null
	fi
}

mkdir -p ${HOME}/.config/zed
tee_out ${HOME}/.config/zed/settings.json <<-'EOF'
{
  "ui_font_size": 16,
  "buffer_font_size": 16,
  "theme": {
    "mode": "system",
    "light": "One Light",
    "dark": "One Dark"
  },
  "languages": {
    "Markdown": {
      "format_on_save": "on"
    }
  }
}
EOF
