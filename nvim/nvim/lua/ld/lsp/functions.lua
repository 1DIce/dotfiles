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
    require("typescript").actions.organizeImports({ sync = true })
    vim.cmd([[ :Prettier ]])
  end
end

return M
