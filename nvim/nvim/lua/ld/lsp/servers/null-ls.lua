local null_ls = require("null-ls")
local lsp = require('lspconfig')

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.black,
    null_ls.builtins.diagnostics.cspell.with({
      filetypes = {},
      severity = 3,
      disabled_filetypes = {"lua", "gitconfig"},
      extra_args = function(params)
        if (lsp.util.root_pattern(".vscode/cspell.json")(params.bufname)) then
          return params.options and {"--config", ".vscode/cspell.json"}

        end
        return params.options
      end,

      cwd = function(params)
        local cwd = lsp.util.root_pattern("tsconfig.json")(params.bufname) or
                        lsp.util.root_pattern(".vscode/")(params.bufname) or
                        lsp.util
                            .root_pattern("package.json", ".git/", ".zshrc")(
                            params.bufname) or
                        lsp.util.path.dirname(params.bufname);
        return cwd
      end

    }), null_ls.builtins.formatting.lua_format.with({
      extra_args = function(params)
        return params.options and {"--indent-width", "2"}
      end
    }), null_ls.builtins.formatting.shfmt
  },
  debounce = 600
})

