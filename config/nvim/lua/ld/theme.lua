vim.cmd('syntax on')

-- vim.cmd('colorscheme codedark')
-- vim.cmd('colorscheme gruvbox')
-- vim.cmd('colorscheme vscode')
-- vim.cmd('colorscheme nvcode')
vim.cmd('colorscheme material')

require("material").setup({
  text_contrast = {darker = true},
  custom_highlights = {
    TSType = {fg = "#34EBCF"},
    TSConstructor = {fg = "#34EBCF"},
    Type = {fg = "#34EBCF"},
    TSFunction = {fg = "#EB34E5"},
    TSMethod = {fg = "#EB34E5"},
    TSProperty = {fg = "#3DA0D1"}
  }
})

vim.g.material_style = "darker"
vim.g.nvcode_termcolors = 256
vim.g.vscode_style = "dark"

vim.o.termguicolors = true
vim.o.background = 'dark'

vim.g.gruvbox_contrast_dark = 'hard'
vim.g.gruvbox_sign_column = 'dark0_hard'
vim.g.gruvbox_invert_selection = 0
vim.g.gruvbox_number_column = 'dark0_hard'
vim.g.gruvbox_invert_tabline = true
-- vim.g.gruvbox_tabline_sel = 'green'

vim.cmd('highlight ColorColumn ctermbg=0 guibg=lightgrey')
vim.cmd('highlight SignColumn guibg=#282828')

