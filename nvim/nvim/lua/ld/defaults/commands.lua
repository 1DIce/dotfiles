vim.api.nvim_create_user_command("NgTestCur", function()
  vim.cmd([[:Tkill | :T npm run test -- --include $(realpath --relative-to . %:p) ]])
end, {})

-- build angular App and fill the quickfix list with issues
vim.api.nvim_create_user_command("NgMake", function()
  vim.cmd(
    [[:setlocal makeprg=ng\ build | setlocal errorformat=%EError:\ %f:%l:%c\ -\ %m,%-G%.%# | :make ]]
  )
end, {})
--
-- run angular App test and fill the quickfix list with issues
vim.api.nvim_create_user_command("NgMakeTest", function()
  vim.cmd(
    [[:setlocal makeprg=ng\ test\ --configuration=ci\ --watch=false | setlocal errorformat=%EError:\ %f:%l:%c\ -\ %m,%-G%.%# | :make]]
  )
end, {})

local getDiffviewOriginalFilePath = function()
  local absolutePath = require("diffview.lib"):get_current_view():infer_cur_file().absolute_path
  if absolutePath then
    os.execute("gitlab-cli file-change " .. absolutePath .. " | xargs xdg-open")
  end
end

vim.api.nvim_create_user_command("DiffviewMrChange", function()
  getDiffviewOriginalFilePath()
end, {})

vim.api.nvim_create_user_command("GenUUID", function()
  local uuid = vim.cmd([[ system("uuidgen")]])
  local pos = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local nline = line:sub(0, pos) .. uuid .. line:sub(pos + 1)
  vim.api.nvim_set_current_line(nline)
end, {})

vim.api.nvim_create_user_command("LspToggleInlayHints", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, {})

vim.api.nvim_create_user_command("Notifications", function()
  Snacks.notifier.show_history()
end, {})

vim.api.nvim_create_user_command("CompareToClipboard", function()
  local get_register_lines = function(reg_name)
    local lines = {}
    for line in vim.fn.getreg(reg_name):gmatch("[^\n]+") do
      table.insert(lines, line)
    end
    return lines
  end
  local setup_current_buffer = function(name, lines)
    vim.cmd.edit(name)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.bo.buftype = "nofile"
    vim.bo.buflisted = false
    vim.cmd.diffthis()
  end
  local current_buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false) -- Get all lines in the current buffer
  vim.cmd.tabnew()
  setup_current_buffer("original", current_buf_lines)

  -- open vertial split
  local register_name = "+"
  vim.cmd.vnew()
  local register_lines = {}
  for line in vim.fn.getreg(register_name):gmatch("[^\n]+") do
    table.insert(register_lines, line)
  end
  setup_current_buffer("clipboard_content", register_lines)
end, {})

vim.api.nvim_create_user_command("PytonFormatBuf", function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false) -- Get all lines in the current buffer
  local single_line = table.concat(lines, "") -- Join all lines
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { single_line }) -- Replace buffer content with the single line
  vim.cmd("%! ruff format -")
end, {})
