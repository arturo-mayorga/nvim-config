local M = {}

-- Function to follow link safely
function M.follow_link()
  local fml = require("follow-md-links")
  local link = fml.get_link_under_cursor()
  if not link or link == "" then return end

  -- If it's a URL or heading link, let the plugin handle it
  if link:match("^https?://") or link:match("^#") then
    return fml.follow_link()
  end

  -- Otherwise try to open as local file path
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
    vim.cmd.edit(vim.fn.fnameescape(file))
  end

  if anchor and anchor ~= "" then
    local pat = "\\v^#+\\s+" .. vim.fn.escape(anchor, "\\/.*$^~[]")
    if vim.fn.search(pat, "w") == 0 then
      vim.fn.search(vim.fn.escape(anchor, "\\/.*$^~[]"), "w")
    end
  end
end

return M