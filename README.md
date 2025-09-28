# nvim-config

A modern Neovim configuration for enhanced development experience, including LSP, DAP, Treesitter, formatting, linting, and AI-powered features.

## Quick Start

To set up this configuration on a fresh Neovim install, simply run:

```bash
curl https://raw.githubusercontent.com/arturo-mayorga/nvim-config/refs/heads/master/bootstrap.sh | bash
```

This will automatically clone the repo and set up all required plugins and settings.

## Features
- LSP support (nvim-lspconfig, mason, mason-lspconfig)
- Formatting & linting (none-ls, mason-null-ls)
- Debugging (nvim-dap, nvim-dap-ui, mason-nvim-dap)
- Treesitter syntax highlighting
- Telescope fuzzy finder
- AI-powered coding (Copilot, CopilotChat)
- Beautiful theme (TokyoNight)

## Manual Installation

1. **Clone the repo:**
   ```bash
   git clone https://github.com/arturo-mayorga/nvim-config.git ~/.config/nvim
   ```
2. **Run the bootstrap script:**
   ```bash
   cd ~/.config/nvim
   bash bootstrap.sh
   ```

## Requirements
- Neovim 0.9+
- Git
- curl

## Recommended
- JetBrainsMono from [nerdfonts.com](https://www.nerdfonts.com/font-downloads)

### Windows Prerequisites
If you are using Windows:
- Make sure you have [Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim#windows) installed and added to your PATH.
- Install [Git for Windows](https://gitforwindows.org/) to get `git` and `bash.exe`.
- Install [curl for Windows](https://curl.se/windows/) if not already available.
- It is recommended to use a terminal that supports UTF-8 and true color (e.g., Windows Terminal).
- For best results, run the setup commands in `bash.exe` (provided by Git for Windows).
- **You must have [Visual Studio Build Tools](https://visualstudio.microsoft.com/visual-cpp-build-tools/) installed.** The bootstrap script will attempt to locate and initialize MSVC automatically. If you do not have Build Tools 2017 or newer, install them before running the setup.

## Customization
Edit files in the `lua/` directory to customize keymaps, plugin settings, and more.

## Troubleshooting
If you encounter issues, check plugin installation and ensure your Neovim version is up to date.

---

Enjoy your new Neovim setup!
