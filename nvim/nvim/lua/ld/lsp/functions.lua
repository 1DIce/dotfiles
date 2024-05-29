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

function M.format_organize_typescript()
  if M.is_deno_workspace() then
    vim.lsp.buf.format({
      filter = function(client)
        return client.name == "denols"
      end,
      async = false,
    })
  else
    require("typescript-tools.api").organize_imports(true)
    vim.lsp.buf.format({
      async = false,
    })
  end
end

function M.go_to_definition()
  local filetype = vim.bo.filetype
  if filetype == "typescript" and util_functions.command_exists("TSToolsGoToSourceDefinition") then
    require("typescript-tools.api").go_to_source_definition(true)
  else
    vim.lsp.buf.definition()
  end
end

return M
