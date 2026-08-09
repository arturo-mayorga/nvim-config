-- lua/keymaps.lua
-- Centralised key mappings for Neovim
--
-- Conventions follow kickstart.nvim / LazyVim where one exists, and defer to
-- Neovim's own built-in defaults (0.11+) rather than re-mapping them.
-- <leader> is set to <Space> in init.lua (before lazy.nvim loads).
--------------------------------------------------------------

local map  = vim.keymap.set
local opts = { noremap = true, silent = true }

local function o(desc)
  return vim.tbl_extend("force", opts, { desc = desc })
end

-- Helper: lazy-require Telescope built-ins --------------------
local function telescope(builtin)
  return function() require("telescope.builtin")[builtin]() end
end

----------------------------------------------------------------
-- Telescope ---------------------------------------------------
----------------------------------------------------------------
-- Standard f-prefix layout: ff = files, fg = grep, fb = buffers.
map("n", "<leader>ff", telescope("find_files"), o("Telescope: find files"))
map("n", "<leader>fg", telescope("live_grep"),  o("Telescope: live grep"))
map("n", "<leader>fb", telescope("buffers"),    o("Telescope: buffers"))
map("n", "<leader>fh", telescope("help_tags"),  o("Telescope: help tags"))

-- Convenience alias, familiar from CtrlP / VS Code. Shadows normal-mode
-- CTRL-P ("move up"), which is redundant with k.
map("n", "<C-p>", telescope("find_files"), o("Telescope: find files"))

----------------------------------------------------------------
-- LSP ---------------------------------------------------------
----------------------------------------------------------------
-- Neovim 0.11+ creates these GLOBAL defaults unconditionally -- do not remap:
--   grn  rename          gra  code action     grr  references
--   gri  implementation  grt  type definition grx  run codelens
--   gO   document symbol i_CTRL-S signature help
--   K    hover (mapped automatically when a client attaches)
-- Only `gd` needs adding, since Neovim leaves it as vanilla "local declaration".
map("n", "gd", vim.lsp.buf.definition, o("LSP: goto definition"))

----------------------------------------------------------------
-- Diagnostics -------------------------------------------------
----------------------------------------------------------------
-- ]d / [d (jump) and <C-w>d (float at cursor) are Neovim built-ins.
map("n", "<leader>q", vim.diagnostic.setloclist, o("Diagnostics -> loclist"))

----------------------------------------------------------------
-- DAP (Debugging) --------------------------------------------
----------------------------------------------------------------
map("n", "<leader>dc", function() require("dap").continue() end,          o("DAP: continue"))
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, o("DAP: toggle breakpoint"))
map("n", "<leader>du", function() require("dapui").toggle() end,          o("DAP-ui: toggle"))

----------------------------------------------------------------
-- Quality-of-life --------------------------------------------
----------------------------------------------------------------
-- Quick save. Deliberately NOT mapped in Insert mode: Neovim 0.11+ reserves
-- i_CTRL-S for vim.lsp.buf.signature_help(). Add "i" back if you prefer save.
map({ "n", "v" }, "<C-s>", "<cmd>w<CR>", o("Save file"))

-- Window navigation like tmux / VS Code
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Paste over selection without clobbering the unnamed register
map("x", "<leader>p", '"_dP', o("Paste w/o clobbering register"))
