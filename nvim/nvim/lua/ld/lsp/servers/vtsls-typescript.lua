local remaps = require("ld.lsp.remaps")
local vscodeSettings = require("ld.lsp.vscode-settings")

M = {}

function M.setup()
  local config = {
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
      complete_function_calls = true,
      vtsls = {
        enableMoveToFileCodeAction = false,
        autoUseWorkspaceTsdk = true,
        experimental = {
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
      },
      typescript = {
        updateImportsOnFileMove = { enabled = "always" },
        suggest = {
          completeFunctionCalls = true,
        },
        preferGoToSourceDefinition = true,
        preferences = {
          quotePreference = vscodeSettings.getValueOr(
            "typescript.preferences.quoteStyle,",
            "double"
          ),
          importModuleSpecifierPreference = vscodeSettings.getValueOr(
            "typescript.preferences.importModuleSpecifier",
            "non-relative"
          ),
          autoImportFileExcludePatterns = {
            "./src/generated/antlr-ruletree/**/*",
            "**/node_modules/@types/node",
            "**/node_modules/@types/lz-string",
            "**/node_modules/lz-string",
            "**/node_modules/tinymce",
            "**/node_modules/dayjs",
            "**/node_modules/ajv",
            "**/node_modules/ajv-formats",
            "**/node_modules/ajv-keywords",
            "**/node_modules/antlr4",
          },
        },
        format = {
          { indentSize = 2 },
        },
      },
    },
  }

  vim.api.nvim_create_user_command("TypescriptRenameFile", "VtsExec rename_file", {})

  return config
end

return M
