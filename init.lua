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


vim.cmd.colorscheme("tokyonight-storm")

-- 3. non‑plugin config ----------------------------------------------------
require("config.lsp")
require("config.dap")
require("config.none-ls")
require("config.treesitter")
require("keymaps")