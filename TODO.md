# mac-setup TODO

Backlog for this repo — not auto-installed. See `setup.sh` for what runs today.

## Maintenance

### Sync `scripts/verify.sh` with `setup.sh`

`mac --verify` should check exactly what setup installs.

| Location | In `setup.sh` only                          | In `verify.sh` only                                  |
| -------- | ------------------------------------------- | ---------------------------------------------------- |
| Formulas | `fzf`, `httpie`, `k9s`, `mkcert`, `ripgrep` | `gradle`, `imagemagick`, `kcat`, `yarn`              |
| Casks    | `google-chrome`, `tableplus`                | `devtoys`, `firefox`, `intellij-idea-ce`, `webstorm` |

Pick one path for each orphan row: add to `setup.sh`, remove from `verify.sh`, or keep as optional and drop from verify.

---

## Optional formulas

Candidates not in `setup.sh`. Add when a project or workflow needs them.

| Package                          | Why                                                              |
| -------------------------------- | ---------------------------------------------------------------- |
| `fd`                             | Fast, friendly `find` replacement                                |
| `bat`                            | Syntax-highlighted `cat` for configs and logs                    |
| `eza` / `lsd`                    | Modern `ls` with icons and git status                            |
| `git-delta`                      | Readable, syntax-highlighted git diffs                           |
| `awscli`                         | AWS CLI (you already have `gcloud-cli`)                          |
| `azure-cli`                      | Azure CLI                                                        |
| `kustomize`                      | K8s config layering, often used with kubectl                     |
| `kind`                           | Kubernetes in Docker — lighter complement to minikube            |
| `tilt` / `skaffold`              | Live-reload dev loops for K8s microservices                      |
| `trivy`                          | Container and image vulnerability scanner                        |
| `pre-commit`                     | Git hook framework for linters before commit                     |
| `just`                           | Command runner — `just test`, `just deploy`                      |
| `make`                           | C/native builds (Xcode CLT may already provide this)             |
| `python`                         | Explicit Python 3 base; `uv` covers most tooling                 |
| `go` / `rust`                    | Language toolchains when those stacks come up                    |
| `gradle`                         | Java build tool — pairs with `openjdk@21`                        |
| `yarn`                           | Node package manager for repos that expect it                    |
| `mysql-client` / `postgresql@16` | DB clients for local and remote work                             |
| `redis`                          | Local Redis instance for development                             |
| `kcat`                           | Kafka produce/consume/debug from the CLI                         |
| `imagemagick`                    | Image convert, resize, and batch processing                      |
| `hyperfine`                      | Benchmark commands and scripts                                   |
| `dive`                           | Inspect Docker image layers to shrink images                     |
| `colima`                         | Lightweight Docker/K8s runtime — pick Docker Desktop **or** this |

Already in `setup.sh`: `ripgrep`, `fzf`, `k9s`, `mkcert`, `httpie`, `stern`, `shfmt`.

---

## Optional casks

| Cask                            | Why                                                      |
| ------------------------------- | -------------------------------------------------------- |
| `1password` / `bitwarden`       | Secrets manager for credentials, SSH keys, API tokens    |
| `dbeaver-community`             | Free DB GUI alternative to TablePlus                     |
| `ngrok` / `cloudflare-tunnel`   | Expose localhost for webhooks and OAuth callbacks        |
| `insomnia`                      | API client alternative to Postman                        |
| `orbstack`                      | Docker Desktop alternative — faster, lower RAM; pick one |
| `visual-studio-code`            | Fallback editor when Cursor is not the right tool        |
| `firefox`                       | Second browser for testing and separate profiles         |
| `devtoys`                       | GUI dev utilities — JSON, YAML, base64, hashing          |
| `intellij-idea-ce`              | Full Java/Kotlin IDE                                     |
| `webstorm`                      | JetBrains JS/TS IDE for large frontends                  |
| `slack` / `zoom`                | Work communication                                       |
| `rectangle` / `bettertouchtool` | Window snapping — complements alt-tab                    |
| `stats` / `btop`                | Menu bar or terminal system monitor                      |
| `wireshark`                     | Packet capture for network debugging                     |
| `proxyman` / `charles`          | HTTP(S) proxy for mobile and web API debugging           |

Already in `setup.sh`: `google-chrome`, `tableplus`, `postman`, `zed`.

---

## Shell and aliases

Alias and function ideas live in `bin/zshrc/TOADD.md`. Move winners into `bin/zshrc/aliases_and_functions.sh`.

Notable cleanups called out there:

- Replace `brew_upgrade` alias with a real upgrade function
- Make `docker_clean` safer or add a confirming `docker_prune`
- Fix `docker_stop` to quit Docker Desktop reliably on macOS
