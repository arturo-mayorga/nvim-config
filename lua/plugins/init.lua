return {
  -- Telescope
  { "nvim-telescope/telescope.nvim", dependencies = "nvim-lua/plenary.nvim" },

  -- LSP + tooling ------------------------------------------------------
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "williamboman/mason-null-ls.nvim" },   -- auto‑installs null‑ls/none‑ls sources

  -- Completion engine and sources
  { "hrsh7th/nvim-cmp" },                   -- completion engine
  { "hrsh7th/cmp-nvim-lsp" },               -- LSP source for cmp
  { "L3MON4D3/LuaSnip" },                   -- Snippet engine (required by cmp)
  { "saadparwaiz1/cmp_luasnip" },           -- Snippet completions
  { "hrsh7th/cmp-buffer" },                 -- Buffer completions (optional)
  { "hrsh7th/cmp-path" },                   -- Filesystem path completions (optional)

  -- Format/lint
  { "nvimtools/none-ls.nvim" },

  -- DAP
  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui", dependencies = "nvim-neotest/nvim-nio" },
  { "jay-babu/mason-nvim-dap.nvim" },

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- AI / Copilot chat
  { "zbirenbaum/copilot.lua",           lazy = false },  
  { "CopilotC-Nvim/CopilotChat.nvim", dependencies = "nvim-lua/plenary.nvim" },

  -- Theme with full Tree‑sitter + LSP support
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },

  -- Auto‑link any missing @lsp.* highlight groups to sane defaults
  { "theHamsta/nvim-semantic-tokens", event = "VeryLazy" },
}
