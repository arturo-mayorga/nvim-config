require("mason-null-ls").setup({
  ensure_installed = { "prettier", "markdownlint" },  -- mason pkg names
  automatic_installation = true,
})
