#!/usr/bin/env bash

brew_install_cask visual-studio-code

EXTENSIONS=($(code --list-extensions | tr '[:upper:]' '[:lower:]'))

vscode_install_extension() {
  if [[ ${#EXTENSIONS[@]} -eq 0 || ! " ${EXTENSIONS[@]} " =~ " $1 " ]]; then
    code --install-extension $1
  fi
}

vscode_install_extension adpyke.vscode-sql-formatter
vscode_install_extension appliedengdesign.vscode-gcode-syntax
vscode_install_extension asciidoctor.asciidoctor-vscode
vscode_install_extension buster.ndjson-colorizer
vscode_install_extension dbaeumer.vscode-eslint
vscode_install_extension dotjoshjohnson.xml
vscode_install_extension esbenp.prettier-vscode
vscode_install_extension fbaligand.vscode-logstash-editor
vscode_install_extension foxundermoon.shell-format
vscode_install_extension github.copilot
vscode_install_extension humao.rest-client
vscode_install_extension mechatroner.rainbow-csv
vscode_install_extension ms-azuretools.vscode-docker
vscode_install_extension ms-python.python
vscode_install_extension ms-vscode-remote.remote-containers
vscode_install_extension oderwat.indent-rainbow
vscode_install_extension randomchance.logstash
vscode_install_extension ria.elastic
vscode_install_extension statiolake.vscode-rustfmt
vscode_install_extension stkb.rewrap
vscode_install_extension vscode-icons-team.vscode-icons
vscode_install_extension xabikos.reactsnippets
vscode_install_extension yzhang.markdown-all-in-one

mkdir -p ${HOME}/Library/Application\ Support/Code/User/snippets

tee ${HOME}/Library/Application\ Support/Code/User/snippets/bash-file-header.code-snippets <<-'EOF' >/dev/null
{
  "Bash File Header": {
    "prefix": [
      "bash"
    ],
    "body": [
      "#!/usr/bin/env bash"
    ]
  }
}
EOF

tee ${HOME}/Library/Application\ Support/Code/User/settings.json <<-'EOF' >/dev/null
{
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true,
  "editor.tabSize": 2,
  "editor.wordWrap": "on",
  "eslint.workingDirectories": ["frontend"],
  "files.autoSave": "afterDelay",
  "git.autofetch": true,
  "git.confirmSync": false,
  "rewrap.wholeComment": true,
  "terminal.integrated.fontFamily": "Hack Nerd Font",
  "workbench.colorTheme": "Dark+",
  "editor.rulers": [
    {
      "column": 80,
      "color": "#5a5a5a80"
    }
  ],
  "[dotenv]": {
    "editor.defaultFormatter": "foxundermoon.shell-format"
  },
  "[ignore]": {
    "editor.defaultFormatter": "foxundermoon.shell-format"
  },
  "[logstash]": {
    "editor.defaultFormatter": "fbaligand.vscode-logstash-editor"
  },
  "[shellscript]": {
    "editor.defaultFormatter": "foxundermoon.shell-format"
  },
  "[sql]": {
    "editor.defaultFormatter": "adpyke.vscode-sql-formatter"
  }
}
EOF

tee ${HOME}/Library/Application\ Support/Code/User/keybindings.json <<-'EOF' >/dev/null
[
  {
      "key": "shift+cmd+c",
      "command": "-workbench.action.terminal.openNativeConsole",
      "when": "!terminalFocus"
  },
  {
      "key": "shift+cmd+c",
      "command": "editor.action.toggleColumnSelection"
  },
  {
      "key": "shift+cmd+d",
      "command": "-workbench.view.debug",
      "when": "viewContainer.workbench.view.debug.enabled"
  },
  {
      "key": "shift+cmd+d",
      "command": "editor.action.duplicateSelection"
  }
]
EOF

if brew ls --versions "duti" >/dev/null; then
  duti -s com.microsoft.VSCode .c all
  duti -s com.microsoft.VSCode .cfg all
  duti -s com.microsoft.VSCode .conf all
  duti -s com.microsoft.VSCode .cpp all
  duti -s com.microsoft.VSCode .cs all
  duti -s com.microsoft.VSCode .css all
  duti -s com.microsoft.VSCode .go all
  duti -s com.microsoft.VSCode .java all
  duti -s com.microsoft.VSCode .js all
  duti -s com.microsoft.VSCode .json all
  duti -s com.microsoft.VSCode .jsx all
  duti -s com.microsoft.VSCode .less all
  duti -s com.microsoft.VSCode .log all
  duti -s com.microsoft.VSCode .lua all
  duti -s com.microsoft.VSCode .md all
  duti -s com.microsoft.VSCode .php all
  duti -s com.microsoft.VSCode .pl all
  duti -s com.microsoft.VSCode .py all
  duti -s com.microsoft.VSCode .rb all
  duti -s com.microsoft.VSCode .sass all
  duti -s com.microsoft.VSCode .scss all
  duti -s com.microsoft.VSCode .toml all
  duti -s com.microsoft.VSCode .ts all
  duti -s com.microsoft.VSCode .tsx all
  duti -s com.microsoft.VSCode .txt all
  duti -s com.microsoft.VSCode .vue all
  duti -s com.microsoft.VSCode .yaml all
  duti -s com.microsoft.VSCode .yml all
  duti -s com.microsoft.VSCode public.data all
  duti -s com.microsoft.VSCode public.json all
  duti -s com.microsoft.VSCode public.plain-text all
  duti -s com.microsoft.VSCode public.python-script all
  duti -s com.microsoft.VSCode public.shell-script all
  duti -s com.microsoft.VSCode public.source-code all
  duti -s com.microsoft.VSCode public.text all
  duti -s com.microsoft.VSCode public.unix-executable all
else
  echo "duti is missing"
fi
