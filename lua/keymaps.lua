-- lua/keymaps.lua

local map = vim.keymap.set

-- Fuzzy file finder
map("n", "<C-p>", require("telescope.builtin").find_files, { desc = "Telescope Find Files" })

-- LSP go to definition
map('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })

-- Add more here later as needed
-- e.g. map("n", "<leader>cc", ":CopilotChatToggle<CR>", { desc = "Toggle Copilot Chat" })
-- map("n", "<leader>cc", ":CopilotChatToggle<CR>", { desc = "Copilot Chat Toggle" })
-- map("n", "<leader>ff", require("telescope.builtin").live_grep, { desc = "Live Grep" })
-- map("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "Find Buffers" })
