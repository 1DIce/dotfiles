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

function M.typescript_organize_imports_sync(bufnr, timeout)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local parameters = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(bufnr) },
  }
  return vim.lsp.buf_request_sync(bufnr, "workspace/executeCommand", parameters, timeout)
end

function M.format_organize_typescript()
  if M.is_deno_workspace() then
    vim.lsp.buf.formatting_sync()
  else
    M.typescript_organize_imports_sync()
    vim.lsp.buf.formatting_sync()
  end
end

function M.go_to_definition()
  local filetype = vim.bo.filetype
  if filetype == "typescript" then
    vim.cmd(":TypescriptGoToSourceDefinition")
  else
    vim.lsp.buf.definition()
  end
end

return M
