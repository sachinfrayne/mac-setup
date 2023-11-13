#!/usr/bin/env bash

brew_install java

if ! java -version 2>&1 >/dev/null | grep -q "version"; then
  sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
fi
