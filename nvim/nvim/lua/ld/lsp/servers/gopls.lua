local function get_current_gomod()
  local file = io.open("go.mod", "r")
  if file == nil then
    return nil
  end

  local first_line = file:read()
  local mod_name = first_line:gsub("module ", "")
  file:close()
  return mod_name
end

M = {}

function M.setup()
  local gopls = {
    filetypes = { "go", "gomod", "gosum", "gotmpl", "gohtmltmpl", "gotexttmpl" },
    message_level = vim.lsp.protocol.MessageType.Error,
    cmd = {
      "gopls",
    },
    root_markers = { "go.work", "go.mod", ".git" },
    flags = { allow_incremental_sync = true, debounce_text_changes = 500 },
    settings = {
      gopls = {
        -- more settings: https://github.com/golang/tools/blob/master/gopls/doc/settings.md
        -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
        -- not supported
        analyses = {
          -- check analyzers for default values
          -- leeave most of them to default
          -- shadow = true,
          -- unusedvariable = true,
          useany = true,
        },
        codelenses = {
          generate = true, -- show the `go generate` lens.
          gc_details = true, -- Show a code lens toggling the display of gc's choices.
          test = true,
          tidy = true,
          vendor = true,
          regenerate_cgo = true,
          upgrade_dependency = true,
        },
        hints = vim.empty_dict(),
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = false,
        matcher = "Fuzzy",
        -- check if diagnostic update_in_insert is set
        diagnosticsDelay = "250ms",
        diagnosticsTrigger = "Edit",
        semanticTokens = true,
        semanticTokenTypes = { string = false }, -- disable semantic string tokens so we can use treesitter highlight injection
        ["local"] = get_current_gomod(),
        gofumpt = false,
      },
    },
  }

  return gopls
end

return M
