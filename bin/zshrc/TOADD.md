# Alias and function ideas for local box

Suggested additions only — not installed yet. Move winners into `aliases_and_functions.sh`.

## Shell and config

| Name | Implementation | Notes |
|------|----------------|-------|
| `c` | `alias c='clear'` | Faster than typing `clear` |
| `reload` | `alias reload='source ~/.zshrc'` | Pick up config after `mac` |
| `path` | `alias path='print -l $path'` | Readable PATH listing |
| `please` | `alias please='sudo'` | `please brew upgrade` |

## Git (you use gh; these are daily drivers)

| Name | Implementation | Notes |
|------|----------------|-------|
| `gs` | `alias gs='git status -sb'` | Short status |
| `gd` | `alias gd='git diff'` | |
| `gds` | `alias gds='git diff --staged'` | |
| `gl` | `alias gl='git log --oneline -20'` | Recent commits |
| `gp` | `alias gp='git pull --rebase'` | Matches your global `pull.rebase` |
| `gcm` | `alias gcm='git commit -m'` | |
| `git-reset-to-origin` | `__git_reset_to_origin` function | Same pattern as upstream reset, for `origin` |

## Docker (Docker Desktop + compose in setup)

| Name | Implementation | Notes |
|------|----------------|-------|
| `d` | `alias d='docker'` | |
| `dc` | `alias dc='docker compose'` | |
| `dps` | `alias dps='docker ps'` | |
| `dpsa` | `alias dpsa='docker ps -a'` | |
| `docker_prune` | function | Safer than `docker_clean`: `docker system prune -af` with optional `--volumes` prompt |

Replace or supplement `docker_clean` — current alias removes **every** container with no confirmation.

## Kubernetes (kubectl, kubectx, stern, helm in setup)

| Name | Implementation | Notes |
|------|----------------|-------|
| `kgp` | `alias kgp='kubectl get pods'` | |
| `kgs` | `alias kgs='kubectl get svc'` | |
| `kgn` | `alias kgn='kubectl get nodes'` | |
| `kctx` | `alias kctx='kubectx'` | Context switch (already installed) |
| `kns` | `alias kns='kubens'` | Namespace switch |
| `kl` | `alias kl='kubectl logs -f'` | Follow pod logs |
| `stern` | use as-is | Already on PATH; alias only if you want a shorter name |

## JSON / YAML (jq, yq in setup)

| Name | Implementation | Notes |
|------|----------------|-------|
| `json` | `alias json='jq .'` | Pretty-print stdin or file |
| `yaml` | `alias yaml='yq eval -P'` | YAML ↔ JSON at the CLI |

## Network and system

| Name | Implementation | Notes |
|------|----------------|-------|
| `ports` | `alias ports='lsof -nP -iTCP -sTCP:LISTEN'` | What is listening |
| `myip` | `alias myip='curl -fsS ifconfig.me; echo'` | Public IP |
| `flushdns` | `alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'` | macOS DNS cache |
| `showfiles` | `alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'` | |
| `hidefiles` | opposite of `showfiles` | |

## Homebrew

| Name | Implementation | Notes |
|------|----------------|-------|
| `brewup` | function | `brew update && brew upgrade && brew cleanup` — likely what you want instead of `brew_upgrade` |
| `brewdeps` | `alias brewdeps='brew uses --installed'` | What depends on a formula |

## Functions worth adding (real logic)

```zsh
# Safer brew upgrade (replace current brew_upgrade alias?)
__brew_upgrade() {
  brew update
  outdated=$(brew outdated --formula)
  [[ -z "$outdated" ]] && echo "Homebrew is up to date." && return 0
  brew upgrade $outdated
  brew cleanup
}

# mkcd — mkdir and cd
__mkcd() { mkdir -p "$1" && cd "$1"; }

# Simple HTTP server in cwd
__serve() { python3 -m http.server "${1:-8000}"; }

# Extract common archives
__extract() {
  case "$1" in
    *.tar.gz|*.tgz) tar -xzf "$1" ;;
    *.tar.bz2) tar -xjf "$1" ;;
    *.zip) unzip "$1" ;;
    *.gz) gunzip "$1" ;;
    *) echo "don't know how to extract $1" >&2; return 1 ;;
  esac
}
```

## Review notes on current aliases

| Alias | Verdict |
|-------|---------|
| `brew_upgrade` | Uses `reinstall`, not `upgrade`; empty `xargs` can error. Prefer `__brew_upgrade` function above. |
| `docker_clean` | Works but nuclear — no prompt, deletes all containers. Consider `docker_prune` with confirmation. |
| `docker_stop` | Fragile (`pkill` on internal Docker process). `osascript -e 'quit app "Docker"'` is more reliable on macOS. |
| `clear` | Good — `\033c` resets scrollback; different from default `clear`. |
| `cp` / `mv` / `mkdir` | Standard `-iv` / `-pv` flags — keep. |
| `grep --color=auto` | Fine on modern macOS BSD grep. |
| `history` / `hgrep` | Good pair; `history` overrides default to numbered output. |
| `tailf` | Minor convenience; `tail -f` is already short. |
| `ll` + `ls -G` | `ll` inherits color via `ls` alias — intentional and correct. |
| `python` | Good — pins Homebrew Python via `DETECTED_PYTHON_PATH`. |
| `cheat` / `git-reset-to-upstream` | Right to keep as functions. |
