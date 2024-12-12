#!/usr/bin/env bash

brew_install zed

tee ${HOME}/.config/zed/settings.json <<-'EOF' >/dev/null
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
