local remaps = require("ld.lsp.remaps")
local events = require("ld.lsp.events")
local vscodeSettings = require("ld.lsp.vscode-settings")

local initOptions = {
  preferences = {
    quotePreference = "double",
    importModuleSpecifierPreference = vscodeSettings.getValueOr(
      "typescript.preferences.importModuleSpecifier",
      "non-relative"
    ),
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

      local cap = client.server_capabilities
      cap.documentFormattingProvider = false -- null-ls handles the formatting
      cap.renameProvider = false
      remaps.set_typescript(client, bufnr)

      events.document_highlight_under_cursor()
    end,
    init_options = initOptions,
    capabilities = modfiedCapabilities,

    settings = settings,
  }
end
