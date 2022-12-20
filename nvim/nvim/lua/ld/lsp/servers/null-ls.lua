local path_util = require("ld.utils.path")
local null_ls = require("null-ls")
local json = require("ld.utils.json")
local lsp = require("lspconfig")

null_ls.setup({
  on_attach = function(client, bufnr)
    require("ld.lsp.remaps").set_default(client, bufnr)
  end,
  sources = {
    null_ls.builtins.formatting.black,
    null_ls.builtins.diagnostics.cspell.with({
      filetypes = {},
      diagnostics_postprocess = function(diagnostic)
        diagnostic.severity = vim.diagnostic.severity["INFO"]
      end,
      disabled_filetypes = { "NvimTree", "lua", "vim", "gitconfig", "vimwiki" },
      extra_args = function(params)
        if lsp.util.root_pattern(".vscode/cspell.json")(params.bufname) then
          return params.options and { "--config", ".vscode/cspell.json" }
        end
        return params.options
      end,

      cwd = function(params)
        local cwd = lsp.util.root_pattern("tsconfig.json")(params.bufname)
          or lsp.util.root_pattern(".vscode/")(params.bufname)
          or lsp.util.root_pattern("package.json", ".git/", ".zshrc")(params.bufname)
          or lsp.util.path.dirname(params.bufname)
        return cwd
      end,
    }),
    null_ls.builtins.code_actions.cspell,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.yamllint,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.code_actions.shellcheck,
    null_ls.builtins.formatting.prettierd,
  },
  debounce = 600,
})

local function build_cspell_json_from_vscode_settings()
  local vscode_cspell_words = require("ld.lsp.vscode-settings").getValueOr("cSpell.words", nil)
  if vscode_cspell_words == nil then
    return
  end

  local vscode_ancestor = path_util.search_ancestors_with_child(".vscode", "dir")
  if vscode_ancestor == nil then
    return nil
  end
  local cspell_json_path = path_util.join(vscode_ancestor, ".vscode/cspell.json")

  local cspell_settings = {}
  if path_util.is_file(cspell_json_path) then
    -- read existing cspell settings
    cspell_settings = json.readJson(cspell_json_path)
  end

  if cspell_settings.words == nil then
    cspell_settings.words = {}
  end
  vim.list_extend(cspell_settings.words, vscode_cspell_words)
  cspell_settings.words = vim.fn.sort(cspell_settings.words)
  cspell_settings.words = vim.fn.uniq(cspell_settings.words)

  json.write_json(cspell_json_path, cspell_settings)
end

vim.api.nvim_create_user_command("CSpellSettingsFromVscode", function()
  build_cspell_json_from_vscode_settings()
end, {})
