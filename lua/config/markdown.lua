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


local function apply_subtle_md_stripes()
  -- Pick gentle shades close to your #222222 base (tokyonight bg in your setup)
  local stripes = {
    "#242424", -- H1
    "#252525", -- H2
    "#242424", -- H3
    "#252525", -- H4
    "#242424", -- H5
    "#252525", -- H6
  }

  for i = 1, 6 do
    -- IMPORTANT: set ONLY bg so we don't touch the heading text color (fg)
    vim.api.nvim_set_hl(0, ("RenderMarkdownH%dBg"):format(i), { bg = stripes[i] })
  end
end

-- Configure render-markdown (only what we need to change)
local ok, rm = pcall(require, "render-markdown")
if ok then
  rm.setup({
    heading = {
      width = "block",  -- no more full-row bands
      -- use the plugin's default background group names, so we only change bg via :hi
      backgrounds = {
        "RenderMarkdownH1Bg",
        "RenderMarkdownH2Bg",
        "RenderMarkdownH3Bg",
        "RenderMarkdownH4Bg",
        "RenderMarkdownH5Bg",
        "RenderMarkdownH6Bg",
      },
      -- DO NOT set 'foregrounds' here → keeps default heading text colors
    },
  })
end

-- Apply now and re-apply after colorscheme/theme reloads
apply_subtle_md_stripes()
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = apply_subtle_md_stripes,
  desc = "Re-apply subtle markdown heading backgrounds after colorscheme",
})

-- (Optional) also reassert when entering markdown buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = apply_subtle_md_stripes,
  desc = "Ensure markdown heading backgrounds stay subtle in markdown buffers",
})
