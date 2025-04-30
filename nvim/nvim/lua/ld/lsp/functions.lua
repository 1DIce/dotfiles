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

function M.is_python_workspace()
  local cwd = vim.fn.getcwd()
  return vim.loop.fs_stat(cwd .. "/pyproject.toml") ~= nil
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
  require("go.format").goimports()
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

---@param action table
---@param buf integer
---@param timeout_ms integer
---@param attempt integer
local function handle_code_action_sync(action, buf, timeout_ms, attempt)
  if attempt > 3 then
    vim.notify("Max resolve attempts reached for action " .. action.kind, vim.log.levels.WARN)
    return
  end

  if action.edit then
    vim.lsp.util.apply_workspace_edit(action.edit, "utf-16")
  elseif action.command then
    vim.lsp.buf.execute_command(action.command)
  else
    -- neovim:runtime/lua/vim/lsp/buf.lua shows how to run a code action
    -- synchronously. This section is based on that.
    local resolve_result = vim.lsp.buf_request_sync(buf, "codeAction/resolve", action, timeout_ms)
    if resolve_result then
      for _, resolved_action in pairs(resolve_result) do
        handle_code_action_sync(resolved_action.result, buf, timeout_ms, attempt + 1)
      end
    else
      vim.notify(
        "Failed to resolve code action " .. action.kind .. " without edit or command",
        vim.log.levels.WARN
      )
    end
  end
end

function M.run_code_action_sync(action_name, buf)
  local params = vim.lsp.util.make_range_params(0, "utf-16")
  params.context = { diagnostics = {}, only = { action_name } }
  local timeout = 1000 --ms
  local result = vim.lsp.buf_request_sync(buf, "textDocument/codeAction", params, timeout)
  for _, res in pairs(result or {}) do
    for _, action in pairs(res.result or {}) do
      handle_code_action_sync(action, buf, timeout, 0)
    end
  end
end

return M
