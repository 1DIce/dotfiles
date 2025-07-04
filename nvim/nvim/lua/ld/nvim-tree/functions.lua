local utils = require("nvim-tree.utils")
local api = require("nvim-tree.api")

local M = {}

M.executeShellCommandOnTreeNode = function()
  local node = api.tree.get_node_under_cursor()

  local answer = vim.fn.input("Execute command: ", ":!cd " .. node.absolute_path .. " && ")
  utils.clear_prompt()

  if answer or #answer >= 0 then
    vim.cmd(answer)
    api.tree.reload()
  end
  return
end

return M
