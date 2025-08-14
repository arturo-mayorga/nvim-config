local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.diagnostics.pylint,
    null_ls.builtins.diagnostics.markdownlint,   -- needs `markdownlint-cli`
    null_ls.builtins.formatting.prettier,        -- prettier also formats Markdown
  },
})
