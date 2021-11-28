vim.cmd('syntax on')

vim.o.termguicolors = true
-- vim.o.background = 'dark'

vim.g.gruvbox_contrast_dark = 'hard'
vim.g.gruvbox_sign_column = 'dark0_hard'
vim.g.gruvbox_invert_selection = 0
vim.g.gruvbox_number_column = 'dark0_hard'
vim.g.gruvbox_invert_tabline = true
-- vim.g.gruvbox_tabline_sel = 'green'

vim.g.tokyonight_style = "night"
vim.g.tokyonight_italic_functions = true
-- vim.g.tokyonight_sidebars = {"qf", "vista_kind", "terminal", "packer"}
-- Change the "hint" color to the "orange" color, and make the "error" color bright red
vim.g.tokyonight_colors = {hint = "orange", error = "#ff0000", bg_sidebar = 'black'}

-- Load the colorscheme
-- require('nightfox').load("nightfox")
vim.cmd('colorscheme darkplus')
-- vim.cmd('colorscheme tokyonight')
-- vim.cmd('colorscheme gruvbox')

-- vim.cmd('highlight ColorColumn ctermbg=0 guibg=lightgrey')
-- vim.cmd('highlight SignColumn guibg=#282828')

