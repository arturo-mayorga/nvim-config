require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup({
  ensure_installed = { "clangd", "pyright", "ts_ls" },
  automatic_installation = true,
})

local lspconfig = require("lspconfig")

if mason_lspconfig.setup_handlers then
  mason_lspconfig.setup_handlers({
    function(server_name)
      lspconfig[server_name].setup({
         on_attach = function(client, bufnr)
          if not client.server_capabilities.semanticTokensProvider then
            -- ask for full tokens when the server is a bit old
            local aug = vim.api.nvim_create_augroup("SemanticTokens", {})
            vim.api.nvim_create_autocmd("BufEnter", {
              buffer = bufnr,
              group  = aug,
              callback = function()
                vim.lsp.semantic_tokens.start(bufnr, client.id)
              end,
              once = true,
            })
          end
        end,
      })
    end
  })
end
