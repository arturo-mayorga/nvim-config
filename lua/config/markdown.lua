local M = {}

-- Function to follow link safely
function M.follow_link()
  vim.notify("running m.follow_link")
  local fml = require("follow-md-links")
  local link = fml.get_link_under_cursor()
  if not link or link == "" then return end

  if link:match("^https?://") or link:match("^#") then
    return fml.follow_link()
  end

  local file, anchor = link:match("^(.-)#(.+)$")
  file = file or link

  vim.notify("Trying to open: " .. file)


  if not file:match("^%a:[/\\]") and not file:match("^/") and not file:match("^~") then
    local base = vim.fn.expand("%:p:h")
    file = vim.fn.fnamemodify(base .. "/" .. file, ":p")
  end

  if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    file = file:gsub("/", "\\")
  end

  vim.notify("Trying to open(win switch): " .. file)

  local escaped = vim.fn.fnameescape(file)

  vim.notify("Trying to open(escaped): " .. escaped)

  local path, lnum = escaped:match("^(.-):(%d+)$")
  if path and lnum then
    vim.notify("lnum: " .. lnum)
    vim.notify("path: " .. path)
    vim.cmd(("edit +%s %s"):format(lnum, path))
  else
    vim.notify("escaped: " .. escaped)
    vim.cmd(("edit %s"):format(escaped))
  end

  if anchor and anchor ~= "" then
    local pat = "\\v^#+\\s+" .. vim.fn.escape(anchor, "\\/.*$^~[]")
    if vim.fn.search(pat, "w") == 0 then
      vim.fn.search(vim.fn.escape(anchor, "\\/.*$^~[]"), "w")
    end
  end
end

return M