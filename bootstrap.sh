#!/usr/bin/env bash
set -euo pipefail

# 0. if we're on Windows, prepare MSVC first -------------------------------
if [[ "$OS" == "Windows_NT" ]]; then
  # Find the newest VS / Build‑Tools install via vswhere (ships with VS ≥2017)
  VSWHERE="/c/Program Files (x86)/Microsoft Visual Studio/Installer/vswhere.exe"
  if [[ -x "$VSWHERE" ]]; then
    VSROOT=$("$VSWHERE" -latest \
                      -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 \
                      -property installationPath | tr -d '\r')
    VSDEV="$VSROOT/Common7/Tools/VsDevCmd.bat"
  else
    # fallback – hard‑code BuildTools 2022
    VSDEV="/c/Program Files (x86)/Microsoft Visual Studio/2022/BuildTools/Common7/Tools/VsDevCmd.bat"
  fi

  # Convert to a proper Windows path for cmd.exe
  VSDEV_WIN=$(cygpath -w "$VSDEV")

  echo "→ Bootstrapping MSVC via: $VSDEV_WIN"

  # one‑shot: run VsDevCmd *and* Neovim in the same cmd session
  cmd.exe /C "\"$VSDEV_WIN\" -arch=x64 -host_arch=x64 \
      && nvim --headless '+Lazy\! sync' +qa"
  exit 0       # everything after this is Linux/macOS only
fi

# 1. Check prerequisites ---------------------------------------------------
if ! command -v nvim >/dev/null 2>&1; then
  echo "Neovim ≥0.9 is required — install it first." >&2
  exit 1
fi
if ! command -v git >/dev/null 2>&1; then
  echo "Git is required." >&2
  exit 1
fi

# 2. Ask Neovim for its own stdpaths ---------------------------------------
CONFIG_DIR=$(nvim -u NONE --headless -c 'lua print(vim.fn.stdpath("config"))' +qa 2>&1)
DATA_DIR=$(nvim  -u NONE --headless -c 'lua print(vim.fn.stdpath("data"))'   +qa 2>&1)
LAZY_PATH="$DATA_DIR/lazy/lazy.nvim"

echo "CONFIG_DIR: $CONFIG_DIR"
echo "DATA_DIR: $DATA_DIR"

# 3. Get your personal config ---------------------------------------------
if [ -d "$CONFIG_DIR/.git" ]; then
  git -C "$CONFIG_DIR" pull --ff-only
else
  git clone https://github.com/arturo-mayorga/nvim-config "$CONFIG_DIR"
fi

# 4. Bootstrap lazy.nvim ---------------------------------------------------
if [ ! -d "$LAZY_PATH" ]; then
  git clone --filter=blob:none https://github.com/folke/lazy.nvim "$LAZY_PATH"
fi

# 5. Install/upgrade plugins ----------------------------------------------
nvim --headless "+Lazy! sync" +qa

echo "✓ Neovim ready to go!"
