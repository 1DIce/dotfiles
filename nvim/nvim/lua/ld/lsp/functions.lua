local ts_utils = require("nvim-lsp-ts-utils")
local M = {}

M.show_diagnostics = function(opts)
  opts = opts or {}
  vim.lsp.diagnostic.set_loclist({ open_loclist = false })
  require("telescope.builtin").loclist(opts)
end

M.is_deno_workspace = function()
  local cwd = vim.fn.getcwd()
  return vim.loop.fs_stat(cwd .. "/deno.json") ~= nil
end

M.format_organize_typescript = function()
  if M.is_deno_workspace() then
    vim.lsp.buf.formatting_sync()
  else
    ts_utils.organize_imports_sync()
    vim.cmd([[ :Prettier ]])
  end
end

return M
