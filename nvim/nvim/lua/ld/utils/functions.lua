local M = {}

function M.starts_with(str, start) return str:sub(1, #start) == start end

function M.ends_with(str, str_end)
  return #str >= #str_end and str:find(str_end, #str - #str_end + 1, true) and
             true or false
end

function M.tprint(table) print(vim.inspect(table)) end

function M.link_highlight(from, to, override)
  local hl_exists, _ = pcall(vim.api.nvim_get_hl_by_name, from, false)
  if override or not hl_exists then
    vim.cmd(('highlight link %s %s'):format(from, to))
  end
end

function M.is_linux() return vim.loop.os_uname().sysname == 'Linux' end

function M.get_visual_text()
  local current_line = vim.api.nvim_get_current_line()
  local start_pos = vim.api.nvim_buf_get_mark(0, "<")
  local end_pos = vim.api.nvim_buf_get_mark(0, ">")

  return string.sub(current_line, start_pos[2], end_pos[2] + 1)
end

return M;
