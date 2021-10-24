local lsp_status = require('lsp-status')
local lsp_installer_servers = require 'nvim-lsp-installer.servers'
local remaps = require('ld.lsp.remaps')
local presentCmpNvimLsp, cmpNvimLsp = pcall(require, 'cmp_nvim_lsp')

-- for debugging lsp
-- Levels by name: 'trace', 'debug', 'info', 'warn', 'error'

vim.lsp.set_log_level('error')

local function on_attach(client, bufnr)
  -- print(client.name)
  remaps.set_default(client, bufnr)
  lsp_status.on_attach(client, bufnr)

  -- adds beatiful icon to completion
  require'lspkind'.init()

  -- add signature autocompletion while typing
  require'lsp_signature'.on_attach({floating_window = false, timer_interval = 500})
end

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = {spacing = 0, prefix = '■'},

  -- see: ":help vim.lsp.diagnostic.set_signs()"
  signs = true,

  update_in_insert = false
})

lsp_status.register_progress()

local capabilities = {};

capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)

if presentCmpNvimLsp then
  capabilities = vim.tbl_extend('keep', capabilities,
                                cmpNvimLsp.update_capabilities(vim.lsp.protocol.make_client_capabilities()))
end

local default_lsp_config = {on_attach = on_attach, capabilities}

local sumenko_config = function(on_attach)
  return {
    -- cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT'
          -- Setup your lua path
          --        path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'}
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file('', true)
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {enable = false}
      }
    }
  }

end

local servers = {
  efm = require('ld.lsp.servers.efm')(),
  bashls = {},
  yamlls = {},
  jsonls = {},
  tsserver = require('ld.lsp.servers.tsserver')(on_attach),
  html = {},
  cssls = {},
  sumneko_lua = sumenko_config(on_attach),
  dockerls = {},
  omnisharp = {},
  vuels = {},
  graphql = {}
}

--[[ lsp_installer.on_server_ready(function(server)
end) ]]

for serverName, config in pairs(servers) do
  local ok, server = lsp_installer_servers.get_server(serverName)
  if ok then
    if not server:is_installed() then
      print('installing ' .. serverName)
      server:install()
    end
  end

  server:setup(vim.tbl_deep_extend('force', default_lsp_config, config))
  vim.cmd [[ do User LspAttachBuffers ]]
end
