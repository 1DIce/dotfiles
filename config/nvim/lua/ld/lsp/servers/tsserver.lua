local remaps = require 'ld.lsp.remaps'

local initOptions = {
  preferences = {
    quotePreference = "double",
    importModuleSpecifierPreference = "non-relative",
    typescript = {format = {indentSize = 2}}
  }
}

return function(on_attach)
  return {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)

      remaps.set_typescript(client, bufnr)

      client.resolved_capabilities.document_rename = false -- renaming is done by angularls
      client.resolved_capabilities.document_formatting = false -- tsserver, stop messing with prettier da fuck!
    end,
    init_options = initOptions
  }
end
