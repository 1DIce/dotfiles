local lib = require 'nvim-tree.lib'
local utils = require 'nvim-tree.utils'

local M = {}

M.executeShellCommandOnTreeNode = function()
  local node = lib.get_node_at_cursor();

  local answer = vim.fn.input('Execute command: ', ":!cd " .. node.absolute_path .. " && ")
  utils.clear_prompt()

  if answer or #answer >= 0 then
    vim.cmd(answer)
    lib.refresh_tree()
  end
  return

end

return M
