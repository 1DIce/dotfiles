M = {}

-- redirect output of command to scratch buffer
function M.command_to_scratch()
  vim.ui.input({ prompt = "enter command", completion = "command" }, function(input)
    if input == nil then
      return
    elseif input == "scratch" then
      input = "echo('')"
    end
    local cmd = vim.api.nvim_exec(input, { output = true })
    local output = {}
    for line in cmd:gmatch("[^\n]+") do
      table.insert(output, line)
    end
    local buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
    vim.api.nvim_win_set_buf(0, buf)
  end)
end

return M
