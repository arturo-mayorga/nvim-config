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


local function set_md_colors()
  -- Make our own gentle bg for headers (or link to Normal to remove stripes entirely)
  vim.api.nvim_set_hl(0, "MDHeadingBg", { link = "Normal" })     -- no stripe
  -- If you want *slight* striping instead, comment the line above and try:
  -- vim.api.nvim_set_hl(0, "MDHeadingBg", { bg = "#242424" })   -- subtle alt bg

  -- Optional: tune bullets/dashes/code to taste
  vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = "#9ece6a", bg = "NONE" })
  vim.api.nvim_set_hl(0, "RenderMarkdownDash",   { fg = "#7aa2f7", bg = "NONE" })
  -- inline/code blocks if you want them flatter:
  -- vim.api.nvim_set_hl(0, "RenderMarkdownCode",        { bg = "#262a33" })
  -- vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline",  { bg = "#1f2335" })
end

local function setup_render_markdown()
  local ok, rm = pcall(require, "render-markdown")
  if not ok then return end

  rm.setup({
    -- only change what we need; keep the rest at defaults
    heading = {
      width = "block",  -- default is "full" (that’s what causes full-width bands) :contentReference[oaicite:1]{index=1}
      -- point all heading backgrounds at our custom group so they’re uniform
      backgrounds = { "MDHeadingBg","MDHeadingBg","MDHeadingBg","MDHeadingBg","MDHeadingBg","MDHeadingBg" },  -- :contentReference[oaicite:2]{index=2}
      -- you can also tweak foregrounds if desired:
      -- foregrounds = { "RenderMarkdownH1","RenderMarkdownH2","RenderMarkdownH3","RenderMarkdownH4","RenderMarkdownH5","RenderMarkdownH6" },
    },
  })

  -- Apply our highlight overrides now and also after any colorscheme change
  set_md_colors()
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function() set_md_colors() end,
    desc = "Reapply markdown highlight tweaks after colorscheme",
  })
end

-- Run once on startup
setup_render_markdown()

-- Also reassert colors whenever a markdown buffer opens (cheap + belt&suspenders)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = set_md_colors,
  desc = "Ensure markdown highlights are applied for markdown buffers",
})

