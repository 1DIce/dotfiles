local download_packer = function()
  if vim.fn.input "Download Packer? (y for yes)" ~= "y" then
    return
  end

  print "Downloading packer.nvim..."
  local directory = vim.fn.stdpath("data") .. "/site/pack/packer/start/"

  vim.fn.mkdir(directory, "p")

  local out = vim.fn.system {
    "git", "clone", "https://github.com/wbthomason/packer.nvim", "--depth",
    "20", directory .. "packer.nvim",
  }

  print(out)
  print "( You'll need to restart now! )"
end

return function()
  if not pcall(require, "packer") then
    download_packer()

    return true
  end

  return false
end