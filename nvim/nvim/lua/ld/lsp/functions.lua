local ts_utils = require('nvim-lsp-ts-utils')
local M = {}

M.show_diagnostics = function(opts)
  opts = opts or {}
  vim.lsp.diagnostic.set_loclist({open_loclist = false})
  require'telescope.builtin'.loclist(opts)
end

M.format_organize_typescript = function()
  ts_utils.organize_imports_sync()
  vim.cmd([[ :Prettier ]])
  -- vim.lsp.buf.formatting_sync()
end

return M
