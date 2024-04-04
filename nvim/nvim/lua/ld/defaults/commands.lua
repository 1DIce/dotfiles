vim.api.nvim_create_user_command("NgTestCur", function()
  vim.cmd([[:Tkill | :T npm run test -- --include $(realpath --relative-to . %:p) ]])
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
