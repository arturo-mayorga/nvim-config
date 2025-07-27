#!/usr/bin/env bash

set -e  # Exit on error
set -u  # Treat unset variables as error

echo "🔧 Bootstrapping NeoVim configuration..."

# Detect platform
OS=$(uname -s)
echo "📦 Detected OS: $OS"

# Determine config location
if [[ "$OS" == "Linux" || "$OS" == "Darwin" ]]; then
  CONFIG_DIR="$HOME/.config/nvim"
elif [[ "$OS" =~ "MINGW" || "$OS" =~ "MSYS" ]]; then
  CONFIG_DIR="$APPDATA/nvim"
else
  echo "❌ Unsupported OS: $OS"
  exit 1
fi

# Clone your NeoVim config
if [ -d "$CONFIG_DIR" ]; then
  echo "📁 Existing config found at $CONFIG_DIR. Skipping clone."
else
  echo "📥 Cloning config into $CONFIG_DIR..."
  git clone https://github.com/arturo-mayorga/nvim-config.git "$CONFIG_DIR"
fi

# Ensure Neovim is installed
if ! command -v nvim &> /dev/null; then
  echo "❌ NeoVim not found. Please install it first."
  exit 1
fi

# Install plugins
echo "🔄 Syncing plugins via Lazy.nvim..."
nvim --headless "+Lazy! sync" +qa

echo "✅ Bootstrap complete!"
