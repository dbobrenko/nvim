#!/usr/bin/env bash

set -e

# 1. Detect OS and install base dependencies
if [ "$(uname)" = "Linux" ]; then
  echo "[INFO] Installing dependencies on Linux..."
  sudo apt update
  sudo add-apt-repository ppa:neovim-ppa/unstable -y
  sudo apt install neovim
  sudo apt install -y zip ripgrep npm python3-pip neovim
elif [ "$(uname)" = "Darwin" ]; then
  echo "[INFO] Installing dependencies on macOS..."
  brew update
  brew install ripgrep zip npm neovim
else
  echo "[ERROR] Unsupported OS. Exiting."
  exit 1
fi

# 2. Install nvm
echo "[INFO] Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

# 3. Reload shell configuration so 'nvm' is available in this script
#    (We try both bash and zsh config files; ignore errors if they don't exist.)
. ~/.bashrc 2>/dev/null || true
. ~/.zshrc  2>/dev/null || true

# 4. Install Node 20 via nvm
echo "[INFO] Installing Node.js v20..."
nvm install 20
nvm use 20

# 5. Install Node-based language servers
echo "[INFO] Installing Node-based language servers..."
npm install -g \
  bash-language-server \
  yaml-language-server \
  vscode-json-languageserver \
  pyright \
  neovim

# 6. Install Python-based LSP servers + formatting tools
echo "[INFO] Installing Python-based LSP/formatters..."
pip3 install --upgrade pip
pip3 install \
  'python-lsp-server[all]' \
  python-lsp-black \
  ruff-lsp \
  pynvim

# Move tmux config.
mv .tmux.conf ${HOME}/.tmux.conf

echo
echo "Neovim & LSP installation complete!"
echo "You can now run 'nvim' to open Neovim."
