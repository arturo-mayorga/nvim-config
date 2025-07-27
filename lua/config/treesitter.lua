-- lua/config/treesitter.lua
require("nvim-treesitter.configs").setup({
  ensure_installed = { "cpp", "python", "typescript", "javascript", "lua", "json" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
})
