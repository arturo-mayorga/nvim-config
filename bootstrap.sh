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

# Clone lazy.nvim directly before launching NeoVim
LAZY_PATH="$(nvim --headless -c 'lua print(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")' +qa 2>/dev/null | tail -n 1 | tr -d '\r\n')"
echo "📝 (from nvim) LAZY_PATH: $LAZY_PATH"
if [ ! -d "$LAZY_PATH" ]; then
  echo "📥 Cloning lazy.nvim plugin manager..."
  git clone --filter=blob:none https://github.com/folke/lazy.nvim "$LAZY_PATH"
fi

echo "📝 CONFIG_DIR: $CONFIG_DIR"
echo "📝 LAZY_PATH: $LAZY_PATH"

# Patch init.lua to prepend lazy.nvim to runtime path
INIT_LUA="$CONFIG_DIR/init.lua"
echo "📝 INIT_LUA: $INIT_LUA"
if ! grep -q 'lazy.nvim' "$INIT_LUA"; then
  echo "🛠️  Patching init.lua to include lazy.nvim bootstrap..."
  sed -i.bak "1i\\
-- Bootstrap lazy.nvim\\
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'\\
if not vim.loop.fs_stat(lazypath) then\\
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', lazypath })\\
end\\
vim.opt.rtp:prepend(lazypath)\\
" "$INIT_LUA"
  echo "✅ Patched init.lua"
fi

# Confirm nvim is installed
if ! command -v nvim &> /dev/null; then
  echo "❌ NeoVim not found. Please install it first."
  exit 1
fi

# Install plugins
echo "🔄 Syncing plugins via lazy.nvim..."
echo "📝 Dumping stdpath('data') from nvim:"
nvim --headless -c 'lua print("NVIM stdpath(data):", vim.fn.stdpath("data"))' +qa

nvim --headless -c 'lua require("lazy").sync()' +qa

echo "✅ Bootstrap complete!"
