local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.diagnostics.pylint,
    null_ls.builtins.diagnostics.markdownlint.with({
      extra_args = {
        "--config",
        vim.fn.stdpath("config") .. "/.markdownlint.json",  -- your file’s path
      },
    }),
    null_ls.builtins.formatting.prettier,
  },
})
