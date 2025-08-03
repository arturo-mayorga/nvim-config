-- config/indent.lua
vim.opt.expandtab = false
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

local space_filetypes = {
  "cpp", "c", "typescript", "javascript", "typescriptreact", "javascriptreact", "python"
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = space_filetypes,
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end
})

