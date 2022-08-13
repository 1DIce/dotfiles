-- vim.cmd("syntax on")

vim.o.termguicolors = true

-- Load the colorscheme
-- require('nightfox').load("nightfox")
-- vim.cmd('colorscheme darkplus')
-- vim.cmd('colorscheme dracula')
-- vim.cmd('colorscheme rose-pine')
-- vim.cmd('colorscheme catppuccin')
-- vim.cmd('colorscheme aurora')
-- vim.cmd('highlight ColorColumn ctermbg=0 guibg=lightgrey')
-- vim.cmd('highlight SignColumn guibg=#282828')

local vscode_dark = function()
  vim.g.vscode_style = "dark"
  -- Enable transparent background.
  vim.g.vscode_transparent = 0
  vim.o.background = "dark"
  vim.cmd([[colorscheme vscode]])
  require("lualine").setup({ options = { theme = "vscode" } })
  vim.cmd("highlight TSVariableBuiltin guifg=#569cd6")
  vim.cmd("highlight TSKeywordReturn guifg=#C586C0")
end

local darkplus = function()
  vim.cmd("colorscheme darkplus")
end

local nightfox = function()
  require("nightfox").load("nightfox")
end

local monokai = function()
  local palette = require("monokai").classic
  require("monokai").setup({
    palette = palette,
    custom_hlgroups = {
      LspReferenceWrite = { bg = palette.base5 },
      LspReferenceRead = { bg = palette.base5 },
      -- LspReferenceText = {bg = palette.grey, fg = palette.diff_add}
    },
  })
end

local tokyonight = function()
  vim.o.background = "dark"
  vim.g.tokyonight_style = "night"
  vim.g.tokyonight_italic_functions = true
  -- vim.g.tokyonight_sidebars = {"qf", "vista_kind", "terminal", "packer"}
  -- -- Change the "hint" color to the "orange" color, and make the "error" color bright red
  -- vim.g.tokyonight_colors = {
  --     hint = "orange",
  --         error = "#ff0000",
  --             bg_sidebar = 'black'
  --             }
  --
  vim.cmd("colorscheme tokyonight")
end

local tokyodark = function()
  vim.g.tokyodark_transparent_background = false
  vim.g.tokyodark_enable_italic_comment = true
  vim.g.tokyodark_enable_italic = true
  vim.g.tokyodark_color_gamma = "1.0"
  vim.cmd("colorscheme tokyodark")
end

local gruvbox = function()
  vim.o.background = "dark"

  vim.g.gruvbox_material_background = "medium"
  vim.g.gruvbox_material_palette = "original"

  vim.cmd("colorscheme gruvbox-material")
end

local gruvbox_baby = function()
  vim.g.gruvbox_baby_background_color = "dark"
  vim.g.gruvbox_baby_function_style = "bold"
  vim.g.gruvbox_baby_keyword_style = "italic"

  vim.g.gruvbox_baby_telescope_theme = 0
  vim.g.gruvbox_baby_transparent_mode = 0

  vim.cmd([[colorscheme gruvbox-baby]])
end

local calvera = function()
  vim.g.calvera_italic_keywords = true
  vim.g.calvera_borders = true
  vim.g.calvera_contrast = true
  vim.g.calvera_custom_colors = {}

  -- Required Setting
  require("calvera").set()
  require("lualine").setup({ options = { theme = "calvera-nvim" } })
end

local github_dark = function()
  require("github-theme").setup({
    theme_style = "dark",
    function_style = "italic",
    dark_float = true,
    dark_sidebar = true,
    sidebars = { "qf", "vista_kind", "terminal", "packer" },

    -- Change the "hint" color to the "orange" color, and make the "error" color bright red
    colors = { hint = "orange", error = "#ff0000" },
  })
end

local onedarkpro = function()
  local onedarkpro = require("onedarkpro")
  onedarkpro.setup({
    hlgroups = {
      TSParameter = { fg = "${white}" },
      TSProperty = { fg = "${white}" },
      TSVariable = { fg = "${white}" },
    },
    options = {
      transparency = false,
      terminal_colors = true,
      window_unfocussed_color = false,
      bold = true,
      italic = true,
    },
  })
  onedarkpro.load()
end

vscode_dark()
-- gruvbox_baby()
-- darkplus()
-- tokyodark()
-- github_dark()
-- onedarkpro()
-- monokai()
-- gruvbox()
