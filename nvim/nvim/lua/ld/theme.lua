vim.cmd('syntax on')

vim.o.termguicolors = true
vim.o.background = 'dark'

vim.g.gruvbox_material_background = 'medium'
vim.g.gruvbox_material_palette = "original"

vim.g.tokyonight_style = "night"
vim.g.tokyonight_italic_functions = true
-- vim.g.tokyonight_sidebars = {"qf", "vista_kind", "terminal", "packer"}
-- Change the "hint" color to the "orange" color, and make the "error" color bright red
vim.g.tokyonight_colors = {
    hint = "orange",
    error = "#ff0000",
    bg_sidebar = 'black'
}

-- Load the colorscheme
-- require('nightfox').load("nightfox")
-- vim.cmd('colorscheme darkplus')
-- vim.cmd('colorscheme tokyonight')
vim.cmd('colorscheme gruvbox-material')
-- vim.cmd('colorscheme dracula')
-- vim.cmd('colorscheme rose-pine')
-- vim.cmd('colorscheme catppuccin')
-- vim.cmd('colorscheme aurora')

-- vim.cmd('highlight ColorColumn ctermbg=0 guibg=lightgrey')
-- vim.cmd('highlight SignColumn guibg=#282828')

