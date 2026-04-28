#!/usr/bin/env bash
#
# vm-setup.sh — bootstrap a fresh dev VM
#
# Usage: bash vm-setup.sh
#

set -euo pipefail

NVM_VERSION="v0.40.4"

install_nvm() {
  if [ -s "$HOME/.nvm/nvm.sh" ]; then
    echo "==> nvm already installed, skipping"
  else
    echo "==> Installing nvm $NVM_VERSION"
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
  fi

  # Load nvm into the current shell so later steps can use `nvm` / `node` / `npm`.
  export NVM_DIR="$HOME/.nvm"
  # shellcheck disable=SC1091
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  # shellcheck disable=SC1091
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

install_node_lts() {
  echo "==> Installing Node.js LTS via nvm"
  nvm install --lts
  nvm use --lts
}

install_corepack() {
  echo "==> Installing latest corepack globally"
  npm install --global corepack@latest
}

enable_pnpm() {
  echo "==> Enabling pnpm via corepack"
  corepack enable pnpm
}

install_claude_code() {
  if command -v claude >/dev/null 2>&1; then
    echo "==> claude already installed, skipping"
    return
  fi
  echo "==> Installing Claude Code"
  curl -fsSL https://claude.ai/install.sh | bash
}

install_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    echo "==> Homebrew already installed, skipping"
  else
    echo "==> Installing Homebrew"
    NONINTERACTIVE=1 /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Locate brew binary across platforms.
  local brew_bin=""
  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [ -x "$candidate" ]; then
      brew_bin="$candidate"
      break
    fi
  done

  if [ -z "$brew_bin" ]; then
    echo "!! Could not locate brew after install" >&2
    return 1
  fi

  # Load brew into the current shell so later steps can use it.
  eval "$("$brew_bin" shellenv)"

  # Persist brew in ~/.bashrc for future shells (idempotent — only append once).
  local shellenv_line="eval \"\$($brew_bin shellenv bash)\""
  if [ -f "$HOME/.bashrc" ] && grep -Fxq "$shellenv_line" "$HOME/.bashrc"; then
    echo "==> brew shellenv already in ~/.bashrc, skipping"
  else
    echo "==> Adding brew shellenv to ~/.bashrc"
    {
      echo ""
      echo "$shellenv_line"
    } >> "$HOME/.bashrc"
  fi
}

BREW_PACKAGES=(
  beads
  neovim
  awscli
  rtk
  schpet/tap/linear
)

install_brew_packages() {
  echo "==> Installing brew packages: ${BREW_PACKAGES[*]}"
  brew install "${BREW_PACKAGES[@]}"
}

install_nvm
install_node_lts
install_corepack
enable_pnpm
install_claude_code
install_homebrew
install_brew_packages

echo "==> Done"
