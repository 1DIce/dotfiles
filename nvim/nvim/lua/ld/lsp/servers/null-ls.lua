local path_util = require("ld.utils.path")
local null_ls = require("null-ls")
local json = require("ld.utils.json")
local lsp = require("lspconfig")
local cspell = require("cspell")

local cspell_config = {
  find_json = function(directory)
    local project_files = vim.fs.find({ "cspell.json" }, { path = "./.vscode/", type = "file" })
    if project_files and project_files[1] then
      return project_files[1]
    end

    -- searching from current working directory upward. Should find the global cspell config in home as a fallback.
    local upward_search_results = vim.fs.find({ ".cspell.json", "cspell.json" }, { upward = true })
    if upward_search_results and upward_search_results[1] then
      return upward_search_results[1]
    end
    vim.notify("WARN: No cspell.json was found!", vim.log.levels.WARN)

    return nil
  end,
}

null_ls.setup({
  on_attach = function(client, bufnr)
    require("ld.lsp.remaps").set_default(client, bufnr)
  end,
  sources = {
    -- cspell might not work without a config file in ./.vscode/cspell.json
    cspell.diagnostics.with({
      filetypes = {},
      method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
      diagnostics_postprocess = function(diagnostic)
        diagnostic.severity = vim.diagnostic.severity["INFO"]
      end,
      disabled_filetypes = {
        "NvimTree",
        "lua",
        "vim",
        "gitconfig",
        "vimwiki",
        "tex",
        "markdown",
        "snacks_dashboard",
      },
      cwd = function()
        return vim.uv.cwd()
      end,
      config = cspell_config,
    }),
    cspell.code_actions.with({
      disabled_filetypes = {
        "NvimTree",
        "lua",
        "vim",
        "gitconfig",
        "vimwiki",
        "tex",
        "markdown",
        "snacks_dashboard",
      },
      cwd = function()
        return vim.uv.cwd()
      end,
      config = cspell_config,
    }),
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.yamllint.with({
      cwd = function()
        return vim.uv.cwd()
      end,
    }),
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
  cspell_settings.language = "en"
  cspell_settings.words = vim.fn.sort(cspell_settings.words)
  cspell_settings.words = vim.fn.uniq(cspell_settings.words)

  json.write_json(cspell_json_path, cspell_settings)
end

vim.api.nvim_create_user_command("CSpellSettingsFromVscode", function()
  build_cspell_json_from_vscode_settings()
end, {})
