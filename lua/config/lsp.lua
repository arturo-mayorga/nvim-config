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
      lspconfig[server_name].setup({})
    end
  })
end
