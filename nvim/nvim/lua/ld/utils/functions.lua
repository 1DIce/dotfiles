local M = {}

function M.starts_with(str, start)
  return str:sub(1, #start) == start
end

function M.ends_with(str, str_end)
  return #str >= #str_end and str:find(str_end, #str - #str_end + 1, true) and true or false
end

-- converts the first charcter of the string to uppercase
function M.firstToUpper(str)
  return (str:gsub("^%l", string.upper))
end

function M.map(tbl, f)
  local t = {}
  for k, v in pairs(tbl) do
    t[k] = f(v)
  end
  return t
end

function M.tprint(table)
  print(vim.inspect(table))
end

--- Checks if a user command is available globally or in the current buffer
---@param command_name bool
---@return bool
function M.command_exists(command_name)
  local global_commands = vim.api.nvim_get_commands({})
  local buffer_commands = vim.api.nvim_buf_get_commands(0, {})
  local commands = vim.tbl_extend("keep", global_commands, buffer_commands)
  return vim.tbl_get(commands, command_name) ~= nil
end

function M.link_highlight(from, to, override)
  local hl_exists, _ = pcall(vim.api.nvim_get_hl_by_name, from, false)
  if override or not hl_exists then
    vim.cmd(("highlight link %s %s"):format(from, to))
  end
end

function M.is_linux()
  return vim.loop.os_uname().sysname == "Linux"
end

function M.is_windows()
  return vim.loop.os_uname().sysname == "Windows_NT"
end

function M.get_visual_text()
  local current_line = vim.api.nvim_get_current_line()
  local start_pos = vim.api.nvim_buf_get_mark(0, "<")
  local end_pos = vim.api.nvim_buf_get_mark(0, ">")

  return string.sub(current_line, start_pos[2], end_pos[2] + 1)
end

-- This function can only be used to modify a single line
function M.add_text_in_current_cursor_postion(text)
  local pos = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local new_line = line:sub(0, pos) .. text .. line:sub(pos + 1)
  vim.api.nvim_set_current_line(new_line)
end

--- Url decodes the text if it is url decoded
---@param text input text to decode
---@return string
function M.url_decode(text)
  local result = vim.fn.substitute(text, "%2C", ",", "ge")
  result = vim.fn.substitute(result, "%3A", ":", "ge")
  result = vim.fn.substitute(result, "%5B", "[", "ge")
  result = vim.fn.substitute(result, "%5D", "]", "ge")
  return result
end

return M
