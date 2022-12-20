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
local doom_one = function()
  vim.g.doom_one_cursor_coloring = true
  vim.g.doom_one_terminal_colors = true
  vim.g.doom_one_italic_comments = true
  vim.g.doom_one_enable_treesitter = true
  -- Color whole diagnostic text or only underline
  vim.g.doom_one_diagnostics_text_color = false
  vim.g.doom_one_transparent_background = false

  -- Pumblend transparency
  vim.g.doom_one_pumblend_enable = false
  vim.g.doom_one_pumblend_transparency = 20

  -- Plugins integration
  vim.g.doom_one_plugin_telescope = true
  vim.g.doom_one_plugin_nvim_tree = true
  vim.g.doom_one_plugin_dashboard = true
  vim.g.doom_one_plugin_startify = true
  vim.g.doom_one_plugin_whichkey = true
  vim.g.doom_one_plugin_indent_blankline = true
  vim.g.doom_one_plugin_vim_illuminate = true
  vim.g.doom_one_plugin_lspsaga = true

  vim.cmd("colorscheme doom-one")
  vim.cmd("highlight @variable.builtin guifg=#569cd6")
end

local vscode_dark = function()
  vim.o.background = "dark"
  local colors = require("vscode.colors").get_colors()
  require("vscode").setup({
    transparent = false,
    italic_comments = false,
    group_overrides = {
      ["@variable.builtin"] = { fg = colors.vscBlue },
      ["@TypescriptPredefinedType"] = { fg = colors.vscBlue },
      ["@TypescriptTypeIdentifier"] = { fg = colors.vscBlueGreen },
    },
  })
  require("lualine").setup({ options = { theme = "vscode" } })
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

local function tokyonight()
  vim.o.background = "dark"

  require("lualine").setup({
    options = {
      theme = "tokyonight",
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

local gruvbox = function()
  vim.o.background = "dark"
  require("gruvbox").setup({
    inverse = true, -- invert background for search, diffs, statuslines and errors
    contrast = "hard", -- can be "hard", "soft" or empty string
    palette_overrides = {},
    overrides = { SignColumn = { bg = "#1d2021" } },
  })
  vim.cmd("colorscheme gruvbox")
end

local gruvbox_material = function()
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
  vim.g.gruvbox_baby_use_original_palette = true
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
  local violet = "#a9a1e1"
  onedarkpro.setup({
    colors = { white = "#cccccc", fg = violet, orange = "#da8548" },
    highlights = {
      ["@property"] = { fg = "${white}" },
      ["@variable"] = { fg = "${white}" },
      ["@TypescriptPredefinedType"] = { fg = "${orange}" },
      ["@parameter.rust"] = { fg = "${white}" },
      ["@field.rust"] = { fg = violet },
      ["@variable.typescript"] = { fg = violet },
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
  require("lualine").setup({ options = { theme = "onedarkpro" } })
  vim.cmd("colorscheme onedark_vivid")
end

-- vscode_dark()
-- doom_one()
-- gruvbox_baby()
-- darkplus()
-- tokyodark()
-- tokyonight()
-- github_dark()
onedarkpro()
-- monokai()
-- gruvbox()
