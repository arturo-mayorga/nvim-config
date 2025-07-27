vim.opt.rtp:prepend(vim.fn.stdpath("config"))
-- init.lua
-- Bootstrap lazy.nvim if not present
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("plugins")

-- Load config
require("config.lsp")
require("config.dap")
require("config.none-ls")
require("config.treesitter")

require("keymaps")

