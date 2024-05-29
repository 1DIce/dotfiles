local function tokyonight()
  vim.o.background = "dark"

  require("tokyonight").setup({
    styles = {
      comments = { italic = false },
      keywords = { italic = false },
    },
  })
  vim.cmd("colorscheme tokyonight-night")
end

local tokyodark = function()
  vim.g.tokyodark_transparent_background = false
  vim.g.tokyodark_enable_italic_comment = true
  vim.g.tokyodark_enable_italic = true
  vim.g.tokyodark_color_gamma = "1.0"
  vim.cmd("colorscheme tokyodark")
end

tokyonight()
