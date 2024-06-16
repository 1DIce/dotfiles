local util_functions = require("ld.utils.functions")
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

M.is_lsp_client_active = function(client_name)
  local clients = vim.lsp.get_active_clients({ name = client_name })
  local filtered_clients = vim.tbl_filter(function(c)
    return c.name == client_name
  end, vim.tbl_values(clients))

  return not vim.tbl_isempty(filtered_clients)
end

function M.typescript_organize_imports_sync(bufnr, timeout)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local parameters = {
    command = "typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(bufnr) },
  }
  return vim.lsp.buf_request_sync(bufnr, "workspace/executeCommand", parameters, timeout)
end

function M.format_organize_typescript()
  if M.is_deno_workspace() then
    vim.lsp.buf.format({
      filter = function(client)
        return client.name == "denols"
      end,
      async = false,
    })
  else
    M.typescript_organize_imports_sync()
    vim.lsp.buf.format({
      async = false,
    })
  end
end

return M
