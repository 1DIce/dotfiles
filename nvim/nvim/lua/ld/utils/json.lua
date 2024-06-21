local file_util = require("ld.utils.file")
local M = {}

function M.readJson(fname)
  local jsonFile = vim.fn.readfile(fname)
  for i, line in ipairs(jsonFile) do
    jsonFile[i] = vim.fn.substitute(line, "//.*$", "", "g")
  end
  local success, json = pcall(vim.fn.json_decode, jsonFile)
  if success then
    return json
  else
    return nil
  end
end

---@param filepath string filepath to write the file to
---@param data table | Array
function M.write_json(filepath, data)
  local json = vim.fn.json_encode(data)
  file_util.write_file(filepath, json)
end

function M.getDeepJsonValue(json, key)
  if json == nil or key == nil then
    return nil
  end

  if json[key] ~= nil then
    -- if the key contains '.' and is valid return the value
    return json[key]
  end

  local keys = vim.split(key, ".", { plain = true })

  local nestedTabel = json
  for _, value in ipairs(keys) do
    nestedTabel = nestedTabel[value]
    if nestedTabel == nil then
      return nil
    end
  end
  return nestedTabel
end

return M
