local remaps = require("ld.lsp.remaps")
local events = require("ld.lsp.events")

local initOptions = {
  preferences = {
    quotePreference = "double",
    importModuleSpecifierPreference = "non-relative",
  },
}

local settings = {
  typescript = { format = { indentSize = 2 } },
  completions = { completeFunctionCalls = true },
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

      events.document_highlight_under_cursor()
    end,
    init_options = initOptions,
    capabilities = modfiedCapabilities,

    settings = settings,
  }
end
