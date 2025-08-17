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
  local stripes = { -- blending 1 to 80
    "#232425", -- H1 text #7aa2f7
    "#242423", -- H2 text #e0af68
    "#242423", -- H3 text #9ece6a   
    "#222424", -- H4 text #1abc9c
    "#242325", -- H5 text #bb9af7
    "#242324", -- H6 text #9d7cd8
    
  }

  for i = 1, 6 do
    -- IMPORTANT: set ONLY bg so we don't touch the heading text color (fg)
    vim.api.nvim_set_hl(0, ("RenderMarkdownH%dBg"):format(i), { bg = stripes[i], default = false })
  end
end

-- Safe plugin setup
local ok, rm = pcall(require, "render-markdown")
if ok then
  rm.setup({
    heading = {
      width = "block",  -- no more full-row bands
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

  -- Apply now and re-apply after colorscheme/theme reloads
  apply_subtle_md_stripes()

  -- Re-apply after theme reloads (colorscheme overrides)
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      vim.schedule(apply_subtle_md_stripes)
    end,
    desc = "Re-apply markdown heading stripes after colorscheme reload",
  })

  -- Re-apply when entering markdown buffers
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
      vim.schedule(apply_subtle_md_stripes)
    end,
    desc = "Ensure markdown heading backgrounds in markdown files",
  })
end
