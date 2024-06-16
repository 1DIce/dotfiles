local remaps = require("ld.lsp.remaps")
local vscodeSettings = require("ld.lsp.vscode-settings")

M = {}

function M.setup()
  require("typescript-tools").setup({
    on_attach = function(client, bufnr)
      local cap = client.server_capabilities
      cap.documentFormattingProvider = false -- null-ls handles the formatting
      cap.renameProvider = false
      remaps.set_typescript(client, bufnr)
    end,

    handlers = {
      ["textDocument/rename"] = function(err, result, ctx, config)
        -- empty handler because renaming should be done by angular client and not by tsserver
      end,
    },
    settings = {
      -- spawn additional tsserver instance to calculate diagnostics on it
      separate_diagnostic_server = true,
      publish_diagnostic_on = "insert_leave",
      expose_as_code_action = { "remove_unused", "fix_all" },
      -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
      -- not exists then standard path resolution strategy is applied
      tsserver_path = nil,
      complete_function_calls = true,
      include_completions_with_insert_text = true,
      tsserver_file_preferences = {
        quotePreference = vscodeSettings.getValueOr("typescript.preferences.quoteStyle,", "double"),
        importModuleSpecifierPreference = vscodeSettings.getValueOr(
          "typescript.preferences.importModuleSpecifier",
          "non-relative"
        ),
      },
      tsserver_format_options = {
        { indentSize = 2 },
      },
    },
  })

  vim.api.nvim_create_user_command("TypescriptRenameFile", function()
    require("typescript-tools.api").rename_file(true)
  end, {})
end

return M
