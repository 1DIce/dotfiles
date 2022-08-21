local lsp = require("lspconfig")
local json = require("ld.utils.json")
local path_util = require("ld.utils.path")

local M = {}

local searchVscodeAncestor = function()
  return lsp.util.search_ancestors(vim.fn.getcwd(), function(path)
    if path_util.is_dir(path_util.join(path, ".vscode")) then
      return path
    end
  end)
end
local getSettingsJsonPath = function()
  local vscodeAncestor = searchVscodeAncestor()
  if vscodeAncestor == nil then
    return nil
  end
  local settingsJsonPath = path_util.join(vscodeAncestor, ".vscode/settings.json")
  if path_util.is_file(settingsJsonPath) then
    return settingsJsonPath
  else
    return nil
  end
end

local settingsJsonCache = nil

local getSettingsJson = function()
  if settingsJsonCache ~= nil then
    return settingsJsonCache
  end

  local jsonPath = getSettingsJsonPath()
  if jsonPath == nil then
    return nil
  end

  local settingsJson = json.readJson(jsonPath)
  settingsJsonCache = settingsJson
  return settingsJson
end

function M.getValueOr(key, default)
  local settingsJson = getSettingsJson()
  local value = json.getDeepJsonValue(settingsJson, key)
  if value == nil then
    return default
  else
    return value
  end
end

return M
