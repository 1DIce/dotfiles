local functions = require "ld.utils.functions"

_G.reload = function()
  local counter = 0

  for moduleName in pairs(package.loaded) do
    if functions.starts_with(moduleName, "ld.") then
      package.loaded[moduleName] = nil
      require(moduleName)
      counter = counter + 1
    end
  end

  -- clear nvim-mapper keys
  vim.g.mapper_records = nil

  print("Reloaded " .. counter .. " modules!")
end

-- Works like "require", but reloads the package before returning it.
RELOAD = function(package_name)
  package.loaded[package_name] = nil
  return require(package_name)
end

