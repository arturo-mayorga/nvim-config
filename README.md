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

---

## Requirements
### Core
- Neovim 0.9+
- Git
- curl

### Recommended

- JetBrainsMono from [nerdfonts.com](https://www.nerdfonts.com/font-downloads)

### Linux / WSL Prerequisites
If you are using Linux or **Windows Subsystem for Linux (WSL)**, make sure the following packages are installed before running the bootstrap script:

```bash
sudo apt update
sudo apt install -y build-essential curl git unzip xclip   python3 python3-venv python3-pip ca-certificates   nodejs npm
```

> **Explanation:**
> - `build-essential` → provides `gcc`, `g++`, and `make` (needed for compiling Treesitter and some native plugins)  
> - `python3-venv` & `python3-pip` → required for Mason Python tools (e.g. `pylint`, `black`, etc.)  
> - `nodejs` & `npm` → required for TypeScript and other LSP servers (`tsserver`, `eslint`, etc.)  
> - `xclip` → enables clipboard integration on Linux  
> - `ca-certificates` → fixes SSL errors during plugin downloads

#### Node Setup Tip
If you prefer a user-managed Node installation, install [nvm](https://github.com/nvm-sh/nvm) and run:
```bash
nvm install --lts
```

#### Permissions Note
Avoid running Neovim with `sudo`. If you accidentally did, some Mason files may be owned by root — fix them with:
```bash
sudo chown -R $(whoami):$(whoami) ~/.local/share/nvim
```

### macOS Prerequisites
If you’re on macOS, install developer tools and Node:
```bash
xcode-select --install
brew install node python3 git curl
```

### Troubleshooting Environment
You can verify all tools are available by running:
```bash
node -v
python3 -m venv --help
gcc --version
```

If any of these commands fail, ensure your PATH includes `/usr/bin`, `/usr/local/bin`, and user-level bins like `~/.local/bin` or `~/.nvm/.../bin`.

---

### Windows Prerequisites
If you are using Windows:
- Install [Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim#windows) and add it to your `PATH`
- Install [Git for Windows](https://gitforwindows.org/) to get `git` and `bash.exe`
- Install [curl for Windows](https://curl.se/windows/)
- Use a terminal that supports UTF-8 and true color (e.g., **Windows Terminal**)
- Run setup commands in `bash.exe` (from Git for Windows)
- Install [Visual Studio Build Tools](https://visualstudio.microsoft.com/visual-cpp-build-tools/) (2017 or newer)
  - The bootstrap script will attempt to locate and initialize MSVC automatically.

---

## Recommended
- Font: [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)

---

## Customization
Edit files in the `lua/` directory to customize keymaps, plugin settings, and more.

---

## Troubleshooting

If you encounter issues:

1. Run:
   ```bash
   :checkhealth
   ```
   inside Neovim to verify all providers and plugins.

2. For Mason installation problems, check the log:
   ```bash
   :MasonLog
   ```

3. For permission issues (e.g., `EACCES`), ensure all Mason directories are owned by your user:
   ```bash
   sudo chown -R $(whoami):$(whoami) ~/.local/share/nvim
   ```

4. If language servers fail to install or start:
   - Verify `node` and `python3` are installed and available in your PATH.
   - Re-run:
     ```bash
     :MasonInstallAll
     ```

---

Enjoy your new Neovim setup!
