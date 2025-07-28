-- lua/config/treesitter.lua
require("nvim-treesitter.configs").setup({
  ensure_installed = { "vimdoc", "cpp", "python", "typescript", "tsx", "javascript", "lua", "json" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
        init_selection    = "<C-space>",
        node_incremental  = "<C-space>",
        node_decremental  = "<BS>",
    },
  },
})
