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

vim.api.nvim_create_autocmd("User", {
  pattern = "HeadlinesSetup",
  callback = function()
    -- Remove or soften alternate background highlights
    vim.api.nvim_set_hl(0, "Headline", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "Headline1", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "Headline2", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "Headline3", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "Headline4", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "Headline5", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "Headline6", { bg = "NONE" })

    -- Bullet characters (●, ◆, etc.)
    vim.api.nvim_set_hl(0, "Dash", { bg = "NONE", fg = "#7aa2f7" })  -- adjust color
    vim.api.nvim_set_hl(0, "Bullet", { bg = "NONE", fg = "#9ece6a" })
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
require("config.mason-null-ls")
require("config.markdown")
require("keymaps")
