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

      -- tsserver, stop messing with prettier da fuck!
      client.resolved_capabilities.document_formatting = false
    end,
    init_options = initOptions
  }
end
