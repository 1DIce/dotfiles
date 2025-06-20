local M = {}

local function find_cspell_config()
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
end

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

function M.setup()
  local lsp_configurations = require("lspconfig.configs")

  if not lsp_configurations.cspell_lsp then
    -- cspell_lsp does not yet exist in lsp config
    -- so i am setting a default config
    lsp_configurations.cspell_lsp = {
      default_config = {
        cmd = { "cspell-lsp", "--stdio", "--config", find_cspell_config() }, -- If the --config parameter is missing it will use the project cspell.json file.
        filetypes = {
          "go",
          "rust",
          "js",
          "ts",
          "html",
          "css",
          "json",
          "yaml",
          "markdown",
          "gitcommit",
          "python",
        },
        root_dir = require("lspconfig.util").root_pattern(".git"),
      },
    }
  else
    vim.notify(
      "WARN: found cspell_lsp in lsp_config. My custom default config is no longer used!!",
      vim.log.levels.WARN
    )
  end
end

return M
