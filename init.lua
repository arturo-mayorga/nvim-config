-- ~/.config/nvim/init.lua -----------------------------------------------
vim.opt.termguicolors = true 

-- 1. bootstrap lazy.nvim -------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2. load plugin specs from lua/plugins/* --------------------------------
require("lazy").setup("plugins", {
  change_detection = { notify = false },
  install          = { colorscheme = { "tokyonight", "habamax" } },
})

require("tokyonight").setup({
  style = "night",        -- night | storm | moon | day
  -- transparent = true,  -- any other options you like
  on_colors = function(colors)
    colors.bg         = "#222222"  -- main background
    colors.bg_dark    = "#1e1e1e"  -- for inactive splits
    colors.bg_float   = "#2a2a2a"  -- floating windows
    colors.bg_popup   = "#2a2a2a"  -- popups / cmp menu
    colors.bg_sidebar = "#1f1f1f"  -- NvimTree / sidebar
    colors.bg_statusline = "#1f1f1f"  -- statusline bg
  end,
})


vim.cmd.colorscheme("tokyonight")

-- 3. non‑plugin config ----------------------------------------------------
require("config.lsp")
require("config.dap")
require("config.none-ls")
require("config.treesitter")
require("config.indent")
require("config.cmp")
require("keymaps")
