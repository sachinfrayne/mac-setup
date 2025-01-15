#!/usr/bin/env bash

mkdir -p ${HOME}/Library/Application\ Support/espanso/match/packages/

cp -f ${HOME}/Source/mac-setup/bin/espanso/*.yml ${HOME}/Library/Application\ Support/espanso/match/packages/

tee ${HOME}/Library/Application\ Support/espanso/match/base.yml <<-'EOF' >/dev/null
matches:
  - trigger: ":espanso"
    replace: "Hi there!"
EOF
