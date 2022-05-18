local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

local isPackerInstalled = function() 
  return fn.empty(fn.glob(install_path)) > 0
end

return function() 
  if not isPackerInstalled() then
    local packer_bootstrap = fn.system({
      "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim",
      install_path,
    })
    print(packer_bootstrap)
    print "( You'll need to restart now! )"
    return true
  end
  
  return false
end
  