-- lua/plugins/init.lua
return require("lazy").setup({
  -- Telescope
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- LSP
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim"},
  { "williamboman/mason-lspconfig.nvim" },

  -- Format/lint
  { "nvimtools/none-ls.nvim" },

  -- DAP
  { "mfussenegger/nvim-dap" },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
  },
  { "jay-babu/mason-nvim-dap.nvim" },

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- CoPilot Chat
  { "CopilotC-Nvim/CopilotChat.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
})
