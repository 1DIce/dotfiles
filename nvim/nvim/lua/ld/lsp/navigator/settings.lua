local navigator = require('navigator')
local remaps = require 'ld.lsp.remaps'

navigator.setup({
  on_attach = function(client, bufnr)
    -- your hook
  remaps.set_default(client, bufnr)

  -- adds beatiful icon to completion
  require'lspkind'.init()
end,

  default_mapping = false, -- set to false if you will remap every key
  treesitter_analysis = true, -- treesitter variable context
  transparency = 50, -- 0 ~ 100 blur the main window, 100: fully transparent, 0: opaque,  set to nil or 100 to disable it
  lsp_installer = true, -- set to true if you would like use the lsp installed by williamboman/nvim-lsp-installer
  lsp = {
    code_action = {enable = true, sign = true, sign_priority = 40, virtual_text = false},
    disable_format_cap = {"tsserver", "html", "css", "sumneko_lua", "eslint", "jsonls"}, -- a list of lsp disable format capacity (e.g. if you using efm or vim-codeformat etc), empty {} by default
    -- disable_lsp = "all", -- a list of lsp server disabled for your project, e.g. denols and tsserver you may
    -- only want to enable one lsp server
    -- to disable all default config and use your own lsp setup set
    -- disable_lsp = 'all'
    -- Default {}
    -- for other style, set to {'╍', 'ﮆ'} or {'-', '='}
    diagnostic_virtual_text = false, -- show virtual for diagnostic message
    diagnostic_update_in_insert = false, -- update diagnostic message in insert mode
    disply_diagnostic_qf = false -- always show quickfix if there are diagnostic errors, set to false if you  want to

,  efm = require('ld.lsp.servers.efm')(),
  jsonls = {init_options = {provideFormatter = false, format = {enable = false}}},
  tsserver = 
  {
    on_attach = function(client, bufnr)
      client.resolved_capabilities.rename = false
      client.resolved_capabilities.document_rename = false -- renaming is done by angularls
      client.resolved_capabilities.document_formatting = false -- tsserver, stop messing with prettier da fuck!
      remaps.set_typescript(client, bufnr)
    end,
    init_options = {  preferences = {
      quotePreference = "double",
      importModuleSpecifierPreference = "non-relative",
      typescript = {format = {indentSize = 2}}
    }
  }
  },
  dockerls = {},
  angularls = {},
  eslint ={
  }
}
})
