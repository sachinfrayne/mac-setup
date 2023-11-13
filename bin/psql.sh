#!/usr/bin/env bash

brew_install libpq
brew link -q --force libpq >/dev/null 2>&1

tee ${HOME}/.psqlrc <<-'EOF' >/dev/null
\pset pager off
EOF
