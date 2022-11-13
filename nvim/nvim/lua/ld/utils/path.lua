local lsp = require("lspconfig")

local M = {
  is_dir = lsp.util.path.is_dir,
  is_file = lsp.util.path.is_file,
  join = lsp.util.path.join,
}

--- Search for ancestor directory that contains the specified child
---@param child_name string
---@param child_type "dir" | "file"
---@param start_directory string?
---@return string
function M.search_ancestors_with_child(child_name, child_type, start_directory)
  start_directory = start_directory or vim.fn.getcwd()
  return lsp.util.search_ancestors(start_directory, function(path)
    if child_type == "dir" and lsp.util.path.is_dir(lsp.util.path.join(path, child_name)) then
      return path
    else
      if child_type == "file" and lsp.util.path.is_file(lsp.util.path.join(path, child_name)) then
        return path
      end
    end
  end)
end

return M
