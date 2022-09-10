local M = {}

function M.readJson(fname)
  local jsonFile = vim.fn.readfile(fname)
  for i, line in ipairs(jsonFile) do
    jsonFile[i] = vim.fn.substitute(line, "//.*$", "", "g")
  end
  local json = vim.fn.json_decode(jsonFile)
  return json
end

function M.getDeepJsonValue(json, key)
  if json == nil or key == nil then
    return nil
  end

  if json[key] ~= nil then
    -- if the key contains '.' and is valid return the value
    return json[key]
  end

  local keys = vim.fn.split(key, ".")

  local nestedTabel = json
  for _, value in ipairs(keys) do
    if nestedTabel == nil then
      return nil
    end
    nestedTabel = nestedTabel[value]
  end
  return nestedTabel
end

return M
