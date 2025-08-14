return {
  -- Telescope
  { "nvim-telescope/telescope.nvim", dependencies = "nvim-lua/plenary.nvim" },

  -- LSP + tooling ------------------------------------------------------
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "williamboman/mason-null-ls.nvim" },   -- auto‑installs null‑ls/none‑ls sources

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

  -- Follow Markdown links with <CR> (files, http(s), #headings, :line)
  { "jghauser/follow-md-links.nvim", ft = { "markdown" } },                   -- :contentReference[oaicite:2]{index=2}

  -- Jump to headings via Telescope
  { "crispgm/telescope-heading.nvim", dependencies = "nvim-telescope/telescope.nvim", config = function()
      require("telescope").load_extension("heading")
    end
  },                                                                           -- :contentReference[oaicite:3]{index=3}

  -- Nice inline rendering of headings/quotes/tables/checkboxes
  { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown" },
    opts = { file_types = { "markdown" } }, },                                 -- :contentReference[oaicite:4]{index=4}

  -- Tables: easy align/format while typing
  { "dhruvasagar/vim-table-mode", ft = { "markdown" } },

  -- Terminal preview (optional, simple)
  { "ellisonleao/glow.nvim", ft = { "markdown" }, config = true }, 
}
