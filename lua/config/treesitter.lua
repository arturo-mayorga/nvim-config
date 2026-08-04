-- lua/config/treesitter.lua
--
-- nvim-treesitter `main` branch (Neovim 0.12+).
-- The `main` rewrite dropped the old `nvim-treesitter.configs` module system:
-- highlighting is now Neovim's own (`vim.treesitter.start`), indentation is an
-- `indentexpr`, and `incremental_selection` no longer exists upstream (a small
-- replacement lives at the bottom of this file).

local ts = require("nvim-treesitter")

local ensure_installed = {
  "vimdoc", "cpp", "python", "typescript", "tsx",
  "javascript", "lua", "json", "markdown", "markdown_inline",
}

-- Async; no-op for parsers that are already present.
ts.install(ensure_installed)

-- Derive the filetypes to activate on from the parser list, so the two stay in
-- sync. `markdown_inline` et al. are injection-only and map to no filetype.
local filetypes = {}
local seen = {}
for _, lang in ipairs(ensure_installed) do
  for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
    if not seen[ft] then
      seen[ft] = true
      filetypes[#filetypes + 1] = ft
    end
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = filetypes,
  callback = function()
    -- Highlighting comes from Neovim itself; nvim-treesitter only supplies queries.
    pcall(vim.treesitter.start)
    -- Indentation is provided by the plugin, and is still marked experimental.
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- ---------------------------------------------------------------------------
-- Incremental selection (replacement for the removed upstream module).
-- Drop this section if you stop using the <C-space> / <BS> mappings.
-- ---------------------------------------------------------------------------

local stack = {} -- bufnr -> array of TSNode, outermost last

local function select_node(node)
  local srow, scol, erow, ecol = node:range()
  -- Treesitter end columns are exclusive; convert to an inclusive visual mark.
  if ecol == 0 and erow > srow then
    erow = erow - 1
    local line = vim.api.nvim_buf_get_lines(0, erow, erow + 1, false)[1] or ""
    ecol = #line
  end
  vim.fn.setpos("'<", { 0, srow + 1, scol + 1, 0 })
  vim.fn.setpos("'>", { 0, erow + 1, math.max(ecol, 1), 0 })
  vim.cmd("normal! gv")
end

local function init_selection()
  local node = vim.treesitter.get_node()
  if not node then
    return
  end
  stack[vim.api.nvim_get_current_buf()] = { node }
  select_node(node)
end

local function node_incremental()
  local buf = vim.api.nvim_get_current_buf()
  local nodes = stack[buf]
  if not nodes or #nodes == 0 then
    return init_selection()
  end
  local current = nodes[#nodes]
  local parent = current:parent()
  -- Skip ancestors spanning exactly the same text, so each press visibly grows.
  while parent and vim.deep_equal({ parent:range() }, { current:range() }) do
    parent = parent:parent()
  end
  if not parent then
    return select_node(current)
  end
  nodes[#nodes + 1] = parent
  select_node(parent)
end

local function node_decremental()
  local buf = vim.api.nvim_get_current_buf()
  local nodes = stack[buf]
  if not nodes or #nodes < 2 then
    return
  end
  nodes[#nodes] = nil
  select_node(nodes[#nodes])
end

vim.keymap.set("n", "<C-space>", init_selection, { desc = "TS: init selection" })
vim.keymap.set("x", "<C-space>", node_incremental, { desc = "TS: expand selection" })
vim.keymap.set("x", "<BS>", node_decremental, { desc = "TS: shrink selection" })

vim.api.nvim_create_autocmd("BufDelete", {
  callback = function(args)
    stack[args.buf] = nil
  end,
})
