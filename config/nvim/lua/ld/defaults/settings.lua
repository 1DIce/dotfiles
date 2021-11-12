-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Let's save undo info!
local cachePath = vim.env.HOME .. "/.cache/nvim"
if (vim.fn.isdirectory(cachePath) == false) then vim.fn.mkdir(cachePath, "", 0770) end
if vim.fn.isdirectory(cachePath .. "/undo-dir") == false then vim.fn.mkdir(cachePath .. "/undo-dir", "", 0700) end
vim.o.undodir = cachePath .. "/undo-dir"
vim.o.undofile = true
-- vim.o.showmatch = true
-- vim.o.nohlsearch
vim.o.hidden = true
vim.o.errorbells = false

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.wrap = false

-- relative line number + absolute current line number
vim.o.relativenumber = true
vim.o.number = true

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.swapfile = false
vim.o.backup = false
vim.o.incsearch = true
vim.o.termguicolors = true
vim.o.scrolloff = 8

-- live preview of substitutions
vim.o.inccommand = 'split'

-- Give more space for displaying messages.
vim.o.cmdheight = 1

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.o.updatetime = 50

-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force user to select one from the menu
vim.o.completeopt = 'menu,menuone,noselect'

-- Don't show the dumb matching stuff.
vim.cmd [[set shortmess+=c]]

-- vim.o.colorcolumn=80

-- lsp column & git column
vim.o.signcolumn = 'yes:2'
-- vim.o.signcolumn = 'number'

vim.g.loaded_matchparen = 1
vim.g.mapleader = ' '

vim.g.wildignorecase = true

vim.o.cursorline = false
vim.o.cursorcolumn = false

-- done by status bar
vim.o.showmode = false

-- fold
vim.wo.foldcolumn = '0' -- defines 1 col at window left, to indicate folding
vim.o.foldlevelstart = 99 -- start file with all folds opened

-- using treesitter for folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

-- shows spaces
vim.o.list = false

vim.o.listchars = 'eol:¬,tab:>·,trail:~,extends:>,precedes:<'
