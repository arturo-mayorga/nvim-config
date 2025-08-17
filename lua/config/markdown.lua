-- lua/config/markdown.lua
local fml = require("follow-md-links")

if not fml._patched_for_windows then
  local original = fml.follow_link

  fml.follow_link = function()
    local link = vim.fn.expand("<cfile>")
    
    if not link or link == "" then return end
    if not (link:match("^https?://") or link:match("^#") or link:match("%.md$") or link:match("^%.?/")) then
      return
    end

    if link:match("^https?://") or link:match("^#") then
      return original()
    end

    local file, anchor = link:match("^(.-)#(.+)$")
    file = file or link

    if not file:match("^/") and not file:match("^%a:[/\\]") and not file:match("^~") then
      local base = vim.fn.expand("%:p:h")
      file = vim.fn.fnamemodify(base .. "/" .. file, ":p")
    end

    local path, lnum = file:match("^(.-):(%d+)$")
    if path and lnum then
      vim.cmd(("edit +%s %s"):format(lnum, vim.fn.fnameescape(path)))
    else
      vim.cmd(("edit %s"):format(vim.fn.fnameescape(file)))
    end

    if anchor and anchor ~= "" then
      local pat = "\\v^#+\\s+" .. vim.fn.escape(anchor, "\\/.*$^~[]")
      if vim.fn.search(pat, "w") == 0 then
        vim.fn.search(vim.fn.escape(anchor, "\\/.*$^~[]"), "w")
      end
    end
  end

  fml._patched_for_windows = true
end

-- Markdown-specific keymaps (on FileType)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(ev)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
    end

    -- Follow link under cursor (follow-md-links maps <CR> already; keep Backspace to jump back)
    map("n", "<BS>", "<cmd>edit #<CR>", "Back to previous file")              -- :contentReference[oaicite:6]{index=6}

    -- Telescope: jump to headings in current buffer
    map("n", "gh", "<cmd>Telescope heading<CR>", "Headings (Telescope)")      -- :contentReference[oaicite:7]{index=7}

    -- Quick preview in terminal
    map("n", "<leader>mp", "<cmd>Glow<CR>", "Markdown preview (Glow)")

    -- Toggle Table Mode
    map("n", "<leader>mt", "<cmd>TableModeToggle<CR>", "Toggle Table Mode")
  end,
})


-- headlines.nvim config and custom highlights
local has_headlines, headlines = pcall(require, "headlines")
if has_headlines then
  headlines.setup({
    markdown = {
      headline_highlights = {
        "CustomHeadline1",
        "CustomHeadline2",
        "CustomHeadline3",
        "CustomHeadline4",
        "CustomHeadline5",
        "CustomHeadline6",
      },
      bullet_highlights = { "CustomBullet" },
      dash_highlight = "CustomDash",
    },
  })

  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
      vim.api.nvim_set_hl(0, "CustomHeadline1", { bg = "#2a2a2a" })
      vim.api.nvim_set_hl(0, "CustomHeadline2", { bg = "#242424" })
      vim.api.nvim_set_hl(0, "CustomHeadline3", { bg = "#2a2a2a" })
      vim.api.nvim_set_hl(0, "CustomHeadline4", { bg = "#242424" })
      vim.api.nvim_set_hl(0, "CustomHeadline5", { bg = "#2a2a2a" })
      vim.api.nvim_set_hl(0, "CustomHeadline6", { bg = "#242424" })

      vim.api.nvim_set_hl(0, "CustomBullet", { fg = "#9ece6a", bg = "NONE" })
      vim.api.nvim_set_hl(0, "CustomDash", { fg = "#7aa2f7", bg = "NONE" })
    end,
  })
end

