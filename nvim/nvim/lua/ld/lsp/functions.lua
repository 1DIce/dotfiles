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

M.is_typescript_workspace = function()
  local cwd = vim.fn.getcwd()
  return vim.loop.fs_stat(cwd .. "/tsconfig.json") ~= nil
    or vim.loop.fs_stat(cwd .. "/package.json") ~= nil
end

M.is_lsp_client_active = function(client_name)
  local clients = vim.lsp.get_clients({ name = client_name })
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
  local client = vim.lsp.get_clients({ bufnr = bufnr, name = "vtsls" })[1]
  if client == nil then
    return
  end
  -- only run this request against the typescript lsp because other lsp server might
  -- simply not respond until the timeout
  return client.request_sync("workspace/executeCommand", parameters, timeout, bufnr)
end

function M.format_organize_typescript(bufnr)
  if M.is_deno_workspace() then
    vim.lsp.buf.format({
      filter = function(client)
        return client.name == "denols"
      end,
      async = false,
    })
  else
    M.typescript_organize_imports_sync(bufnr)
    vim.lsp.buf.format({ async = false, bufnr = bufnr })
  end
end

function M.format_organize_golang(bufnr)
  -- source: https://github.com/golang/tools/blob/master/gopls/doc/vim.md#imports-and-formatting
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }
  -- buf_request_sync defaults to a 1000ms timeout. Depending on your
  -- machine and codebase, you may want longer. Add an additional
  -- argument after params if you find that you have to write the file
  -- twice for changes to be saved.
  -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
  for cid, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
        vim.lsp.util.apply_workspace_edit(r.edit, enc)
      end
    end
  end
  vim.lsp.buf.format({ async = false, bufnr = bufnr })
end

function M.rename()
  if M.is_lsp_client_active("vtsls") and M.is_lsp_client_active("angularls") then
    local bufnr = vim.api.nvim_get_current_buf()
    local buf_name = vim.api.nvim_buf_get_name(bufnr)
    if vim.endswith(buf_name, "component.ts") then
      vim.lsp.buf.rename(nil, { name = "angularls" })
    else
      vim.lsp.buf.rename(nil, { name = "vtsls" })
    end
  else
    vim.lsp.buf.rename()
  end
end

return M
