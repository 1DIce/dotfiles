local remaps = require 'ld.lsp.remaps'

local initOptions = {
  preferences = {
    quotePreference = "double",
    importModuleSpecifierPreference = "non-relative",
    typescript = {format = {indentSize = 2}}
  }
}

return function(on_attach, capabilities)
  local modfiedCapabilities = vim.deepcopy(capabilities)
  modfiedCapabilities.textDocument.rename = false

  return {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)

      client.resolved_capabilities.rename = false
      client.resolved_capabilities.document_rename = false -- renaming is done by angularls
      client.resolved_capabilities.document_formatting = false -- tsserver, stop messing with prettier da fuck!
      remaps.set_typescript(client, bufnr)

    end,
    init_options = initOptions,
    capabilities = modfiedCapabilities

  }
end
