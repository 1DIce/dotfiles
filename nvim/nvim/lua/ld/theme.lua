local function tokyonight()
  vim.o.background = "dark"

  require("tokyonight").setup({
    style = "night",
    styles = {
      comments = { italic = false },
      keywords = { italic = false },
    },
  })
  vim.cmd("colorscheme tokyonight")
end

local tokyodark = function()
  vim.g.tokyodark_transparent_background = false
  vim.g.tokyodark_enable_italic_comment = true
  vim.g.tokyodark_enable_italic = true
  vim.g.tokyodark_color_gamma = "1.0"
  vim.cmd("colorscheme tokyodark")
end

local cyberdream = function()
  vim.cmd("colorscheme cyberdream")
end

local function gruvbox()
  vim.o.background = "dark" -- or "light" for light mode
  require("gruvbox").setup({ contrast = "hard" })
  vim.cmd([[colorscheme gruvbox]])
end

local function vscode()
  vim.o.background = "dark" -- or "light" for light mode
  require("vscode").setup({})
  vim.cmd.colorscheme("vscode")
end

local function kanagawa()
  vim.cmd("colorscheme kanagawa")
end

tokyonight()
-- gruvbox()
-- cyberdream()
-- vscode()
-- kanagawa()
