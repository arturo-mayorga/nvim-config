-- lua/keymaps.lua
-- Centralised key mappings for Neovim
--------------------------------------------------------------

local map  = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Helper: lazy‑require Telescope built‑ins --------------------
local function telescope(builtin)
  return function() require("telescope.builtin")[builtin]() end
end

----------------------------------------------------------------
-- Telescope ---------------------------------------------------
----------------------------------------------------------------
map("n", "<C-p>",   telescope("find_files"),  vim.tbl_extend("force", opts, { desc = "Telescope: find files" }))
map("n", "<leader>ff", telescope("live_grep"), vim.tbl_extend("force", opts, { desc = "Telescope: live grep" }))
map("n", "<leader>fb", telescope("buffers"),   vim.tbl_extend("force", opts, { desc = "Telescope: buffers" }))

----------------------------------------------------------------
-- LSP ---------------------------------------------------------
----------------------------------------------------------------
map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "LSP: goto definition" }))
map("n", "K",  vim.lsp.buf.hover,      vim.tbl_extend("force", opts, { desc = "LSP: hover doc" }))
map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP: rename symbol" }))

----------------------------------------------------------------
-- Diagnostics -------------------------------------------------
----------------------------------------------------------------
map("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Prev diagnostic" }))
map("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
map("n", "<leader>dl", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Line diagnostics" }))
map("n", "<leader>dq", vim.diagnostic.setloclist, vim.tbl_extend("force", opts, { desc = "Diagnostics → loclist" }))

----------------------------------------------------------------
-- DAP (Debugging) --------------------------------------------
----------------------------------------------------------------
map("n", "<leader>dc", function() require("dap").continue() end,          vim.tbl_extend("force", opts, { desc = "DAP: continue" }))
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, vim.tbl_extend("force", opts, { desc = "DAP: toggle breakpoint" }))
map("n", "<leader>du", function() require("dapui").toggle() end,          vim.tbl_extend("force", opts, { desc = "DAP‑ui: toggle" }))

----------------------------------------------------------------
-- Quality‑of‑life --------------------------------------------
----------------------------------------------------------------
-- Quick save in any mode
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR>", vim.tbl_extend("force", opts, { desc = "Save file" }))

-- Window navigation like tmux / VS Code
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Paste over selection without yanking it
map("x", "<leader>p", '"_dP', vim.tbl_extend("force", opts, { desc = "Paste w/o clobbering register" }))

----------------------------------------------------------------
-- Markdown ---------------------------------------------------
----------------------------------------------------------------
map("n", "<BS>", "<cmd>edit #<CR>", "Back to previous file")             -- Follow link under cursor (follow-md-links maps <CR> already; keep Backspace to jump back)
map("n", "gh", "<cmd>Telescope heading<CR>", "Headings (Telescope)")     -- Telescope: jump to headings in current buffer
map("n", "<leader>mp", "<cmd>Glow<CR>", "Markdown preview (Glow)")       -- Quick preview in terminal
map("n", "<leader>mt", "<cmd>TableModeToggle<CR>", "Toggle Table Mode")  -- Toggle Table Mode
