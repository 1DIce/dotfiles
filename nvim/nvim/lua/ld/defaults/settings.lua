vim.o.exrc = true
-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Let's save undo info!
local cachePath = vim.env.HOME .. "/.cache/nvim"
if vim.fn.isdirectory(cachePath) == false then
  vim.fn.mkdir(cachePath, "", 0770)
end
if vim.fn.isdirectory(cachePath .. "/undo-dir") == false then
  vim.fn.mkdir(cachePath .. "/undo-dir", "", 0700)
end
vim.o.undodir = cachePath .. "/undo-dir"
vim.o.undofile = true

vim.cmd.packadd("nvim.undotree")
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

-- don not consider things like col-8 as negative number when incrementing with <c-A>
vim.opt.nrformats:append({ "blank" })

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.swapfile = false
vim.o.backup = false
vim.o.incsearch = true
vim.o.termguicolors = true
vim.o.scrolloff = 8

-- live preview of substitutions
vim.o.inccommand = "split"

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
vim.o.completeopt = "menu,menuone,noselect"
vim.o.complete = ".,w,t"

-- use ripgrep as the grep command
vim.o.grepprg = "rg --vimgrep --no-heading --smart-case --hidden"
vim.o.grepformat = "%f:%l:%c:%m"

-- Don't show the dumb matching stuff.
vim.cmd([[set shortmess+=c]])

-- vim.o.colorcolumn=80

-- lsp column & git column
vim.o.signcolumn = "yes:2"
-- vim.o.signcolumn = 'number'

vim.g.loaded_matchparen = 1

vim.g.wildignorecase = true

vim.o.cursorline = false
vim.o.cursorcolumn = false

-- done by status bar
vim.o.showmode = false

-- fold
vim.wo.foldcolumn = "0" -- defines 1 col at window left, to indicate folding
vim.o.foldlevelstart = 99 -- start file with all folds opened

vim.cmd("let g:vim_json_syntax_conceal = 0")

vim.o.sessionoptions =
  "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- setting global border style for all floating windows
vim.o.winborder = "rounded"
vim.o.pumborder = "rounded"

-- shows spaces
vim.o.list = false

vim.o.fixendofline = false

vim.o.listchars = "eol:¬,tab:>·,trail:~,extends:>,precedes:<"

-- configuraton for experimental ui2
require("vim._core.ui2").enable({
  enable = true, -- Whether to enable or disable the UI.
  msg = { -- Options related to the message module.
    ---@type 'cmd'|'msg' Default message target, either in the
    ---cmdline or in a separate ephemeral message window.
    ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
    ---or table mapping |ui-messages| kinds and triggers to a target.
    targets = "cmd",
    cmd = { -- Options related to messages in the cmdline window.
      height = 0.5, -- Maximum height while expanded for messages beyond 'cmdheight'.
    },
    dialog = { -- Options related to dialog window.
      height = 0.5, -- Maximum height.
    },
    msg = { -- Options related to msg window.
      height = 0.5, -- Maximum height.
      timeout = 4000, -- Time a message is visible in the message window.
    },
    pager = { -- Options related to message window.
      height = 1, -- Maximum height.
    },
  },
})
