require("mason-nvim-dap").setup({
  ensure_installed = { "cppdbg", "debugpy", "node2" },
  automatic_installation = true,
})

require("dapui").setup()
