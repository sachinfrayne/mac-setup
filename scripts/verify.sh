#!/usr/bin/env bash
#
# verify.sh - Verify mac-setup installations and configurations
#
# This script checks that all packages, configurations, and customizations
# are properly installed and configured.
#

set -euo pipefail

# Colors for output
if [[ -t 1 ]]; then
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color
else
    GREEN=''
    RED=''
    YELLOW=''
    BLUE=''
    NC=''
fi

# Counters
PASS_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0

# Check functions
check_pass() {
    echo -e "${GREEN}✓${NC} $1"
    (( ++PASS_COUNT ))
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    (( ++FAIL_COUNT ))
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    (( ++WARN_COUNT ))
}

check_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

echo "mac-setup Verification"
echo "======================"
echo ""

# Check Homebrew
echo "Checking Homebrew..."
if command -v brew &>/dev/null; then
    check_pass "Homebrew is installed ($(brew --version | head -1))"
else
    check_fail "Homebrew is not installed"
fi
echo ""

# Check Homebrew Formulas
echo "Checking Homebrew Formulas..."
FORMULAS=(
    crane
    direnv
    docker-compose
    gemini-cli
    gh
    gradle
    helm
    htop
    imagemagick
    jq
    kcat
    kubectl
    kubectx
    minikube
    node
    nvm
    ollama
    openjdk@21
    shellcheck
    shfmt
    skopeo
    stern
    terraform
    uv
    watch
    yarn
    yq
)

for formula in "${FORMULAS[@]}"; do
    if brew list --formula "$formula" &>/dev/null; then
        check_pass "Formula: $formula"
    else
        check_fail "Formula missing: $formula"
    fi
done
echo ""

# Check Homebrew Casks
echo "Checking Homebrew Casks..."
CASKS=(
    alt-tab
    claude-code
    cursor
    devtoys
    docker
    espanso
    firefox
    font-hack-nerd-font
    gcloud-cli
    intellij-idea-ce
    iterm2
    lens
    logi-options+
    lulu
    postman
    raycast
    webstorm
    zed
)

for cask in "${CASKS[@]}"; do
    if brew list --cask "$cask" &>/dev/null; then
        check_pass "Cask: $cask"
    else
        check_fail "Cask missing: $cask"
    fi
done
echo ""

# Check Configuration Files
echo "Checking Configuration Files..."

if [[ -f "${HOME}/.zshrc" ]]; then
    check_pass ".zshrc exists"
else
    check_fail ".zshrc is missing"
fi

if [[ -f "${HOME}/.zsh/.zlocal" ]]; then
    check_pass ".zsh/.zlocal exists"
else
    check_warn ".zsh/.zlocal is missing (optional local customizations)"
fi

if [[ -d "${HOME}/.config/zed" ]]; then
    check_pass "Zed config directory exists"
else
    check_warn "Zed config directory missing"
fi

if [[ -d "${HOME}/Library/Application Support/Cursor/User" ]]; then
    check_pass "Cursor config directory exists"
else
    check_warn "Cursor config directory missing"
fi

if [[ -d "${HOME}/Library/Application Support/espanso" ]]; then
    check_pass "Espanso config directory exists"
else
    check_warn "Espanso config directory missing"
fi

echo ""

# Check Git Configuration
echo "Checking Git Configuration..."

if git config --global user.name &>/dev/null; then
    check_pass "Git user.name configured: $(git config --global user.name)"
else
    check_fail "Git user.name not configured"
fi

if git config --global user.email &>/dev/null; then
    check_pass "Git user.email configured: $(git config --global user.email)"
else
    check_fail "Git user.email not configured"
fi

if git config --global credential.helper &>/dev/null; then
    check_pass "Git credential helper configured: $(git config --global credential.helper)"
else
    check_warn "Git credential helper not configured"
fi

if [[ "$(git config --global pull.rebase)" == "true" ]]; then
    check_pass "Git pull.rebase is enabled"
else
    check_warn "Git pull.rebase not enabled"
fi

echo ""

# Check ZSH Plugins
echo "Checking ZSH Plugins..."

if [[ -d "${HOME}/.zsh/custom/plugins/powerlevel10k" ]]; then
    check_pass "Powerlevel10k theme installed"
else
    check_fail "Powerlevel10k theme missing"
fi

if [[ -d "${HOME}/.zsh/custom/plugins/zsh-autosuggestions" ]]; then
    check_pass "ZSH autosuggestions installed"
else
    check_fail "ZSH autosuggestions missing"
fi

if [[ -d "${HOME}/.zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
    check_pass "ZSH syntax highlighting installed"
else
    check_fail "ZSH syntax highlighting missing"
fi

echo ""

# Check PATH modifications
echo "Checking PATH and Environment..."

if [[ -f "${HOME}/.zshrc" ]]; then
    if grep -q "brew shellenv" "${HOME}/.zshrc"; then
        check_pass ".zshrc sources Homebrew environment"
    else
        check_warn ".zshrc doesn't source Homebrew environment"
    fi

    if grep -q "NVM_DIR" "${HOME}/.zshrc"; then
        check_pass ".zshrc configures NVM"
    else
        check_warn ".zshrc doesn't configure NVM"
    fi

    if grep -q "JAVA_HOME" "${HOME}/.zshrc"; then
        check_pass ".zshrc configures JAVA_HOME"
    else
        check_warn ".zshrc doesn't configure JAVA_HOME"
    fi

    if grep -q "direnv hook" "${HOME}/.zshrc"; then
        check_pass ".zshrc configures direnv"
    else
        check_warn ".zshrc doesn't configure direnv"
    fi
fi

echo ""

# Check Aliases
echo "Checking Aliases..."

if [[ -f "${HOME}/.zshrc" ]]; then
    if grep -q "alias mac=" "${HOME}/.zshrc"; then
        check_pass ".zshrc defines 'mac' alias"
    else
        check_fail ".zshrc doesn't define 'mac' alias"
    fi

    if grep -q "alias k=" "${HOME}/.zshrc"; then
        check_pass ".zshrc defines 'k' (kubectl) alias"
    else
        check_warn ".zshrc doesn't define 'k' alias"
    fi
fi

echo ""

# Check Cursor Skills Symlink
echo "Checking Cursor Skills..."

if [[ -L "${HOME}/.cursor/skills" ]]; then
    target="$(readlink "${HOME}/.cursor/skills")"
    check_pass "Cursor skills symlink exists -> $target"
elif [[ -d "${HOME}/.cursor/skills" ]]; then
    check_warn "Cursor skills is a directory (not a symlink)"
else
    check_info "Cursor skills directory not set up"
fi

echo ""

# Summary
echo "======================================"
echo "Verification Summary"
echo "======================================"
echo -e "${GREEN}Passed:  ${PASS_COUNT}${NC}"
echo -e "${YELLOW}Warnings: ${WARN_COUNT}${NC}"
echo -e "${RED}Failed:  ${FAIL_COUNT}${NC}"
echo ""

if [[ $FAIL_COUNT -eq 0 ]]; then
    echo -e "${GREEN}✓ All critical checks passed!${NC}"
    if [[ $WARN_COUNT -gt 0 ]]; then
        echo -e "${YELLOW}  Some optional items have warnings (see above)${NC}"
    fi
    exit 0
else
    echo -e "${RED}✗ Some checks failed. Review the output above.${NC}"
    echo "  Run './setup.sh' to fix missing installations."
    exit 1
fi
