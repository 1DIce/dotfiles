local lsp = require("lspconfig")

local M = {
  is_dir = lsp.util.path.is_dir,
  is_file = lsp.util.path.is_file,
  join = lsp.util.path.join,
}

return M
