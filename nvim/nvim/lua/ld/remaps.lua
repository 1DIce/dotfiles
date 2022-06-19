-- reload
nnoremap("<leader><CR>", "<cmd>lua reload()<CR>", "Reloads configuration")

-- toggle spellcapcheck
nnoremap("<leader>vt",
    "<cmd>setlocal spell! spelllang=en_us spelloptions=camel<CR>",
    "Toggle spell check")

-- Y should yank until end of line similar to D and C
nnoremap("Y", "y$", "Yank to end of line")

-- do not replace register content when pasting in visual mode
vnoremap("p", "pgvy", "Paste does not replace register content")

-- deletes in visual
vnoremap("X", "\"_d", "Deletes on visual")

-- when going to next search, we center screen
nnoremap("n", "nzzzv", "When going to next search, we center screen")
nnoremap("N", "Nzzzv", "When going to previous search, we center screen")

-- navigate quick fix
nnoremap("<leader>qo", ":copen<CR>", "Open quickfix list")
nnoremap("<leader>qc", ":cclose<CR>", "Close quickfix list")
nnoremap("<leader>qn", ":cnext<CR>", "Navigate to next quickfix")
nnoremap("<leader>qp", ":cprev<CR>", "Navigate to previous quickfix")

-- navigate command mode autocomplete
cnoremap("<C-j>", "<C-n>", "Select next command mode suggestion")
cnoremap("<C-k>", "<C-p>", "Select previous command mode suggestion")

-- maps c-n / c-t to navigate while searching with /
vim.api.nvim_exec([[
cnoremap <expr> <c-n> getcmdtype() =~ '[\/?]' ? '<c-g>' : '<c-n>'
cnoremap <expr> <c-p> getcmdtype() =~ '[\/?]' ? '<c-t>' : '<c-p>'
]], false)

-- save buffer
nnoremap("<leader><leader>s", "<cmd>write<CR>", "save current buffer")

-- editing remaps
nnoremap("<leader>ej", "<cmd>join<CR>", "join 2 lines")

-- Undo break points
inoremap(",", ",<C-g>u", "add undo break point after ,")
inoremap(".", ".<C-g>u", "add undo break point after .")
inoremap("?", "?<C-g>u", "add undo break point after ?")
inoremap("[", "[<C-g>u", "add undo break point after [")
inoremap("]", "]<C-g>u", "add undo break point after ]")
inoremap("{", "{<C-g>u", "add undo break point after {")
inoremap("}", "}<C-g>u", "add undo break point after }")

-- Moving text up and down youtube https://youtu.be/hSHATqh8svM
nnoremap("<A-j>", ":m .+1<CR>==", "Move current line down")
nnoremap("<A-k>", ":m .-2<CR>==", "Move current line up")
vnoremap("<A-j>", ":m '>+1<CR>gv=gv", "Move current selection down")
vnoremap("<A-k>", ":m '<-2<CR>gv=gv", "Move current selection up")

-- terminal binginds
-- go to normal mode
tnoremap("<C-s>", "<C-\\><C-n>", "Enter terminal normal mode")

tnoremap("<C-w>h", "<C-\\><C-n><C-w>h", "Terminal switch pane left")
tnoremap("<C-w>l", "<C-\\><C-n><C-w>l", "Terminal switch pane right")
tnoremap("<C-w>j", "<C-\\><C-n><C-w>j", "Terminal switch pane down")
tnoremap("<C-w>k", "<C-\\><C-n><C-w>k", "Terminal switch pane up")

-- buffer
nnoremap("<leader>bd", "<cmd>bd<CR>", "Deletes buffer")
nnoremap("<leader>bD", "<cmd>bd!<CR>", "Force delete buffer")
nnoremap("<leader>bo", "<cmd>BufOnly<CR>",
    "Deletes all other buffers except yours")
nnoremap("<leader>bad", "<cmd>%bd<CR>", "Deletes all buffers")
nnoremap("<leader>bw", "<cmd>update<CR>", "Saves/writes/updates buffer")
nnoremap("<leader>bW", "<cmd>update!<CR>", "Force save/write/update buffer")

-- window
nnoremap("<leader>wm", "<cmd>MaximizerToggle<CR>", "window_toggle_maximize")

nnoremap("<leader>wh", "<cmd>wincmd h<CR>", "Move window left")
nnoremap("<leader>wj", "<cmd>wincmd j<CR>", "Move window down")
nnoremap("<leader>wk", "<cmd>wincmd k<CR>", "Move window up")
nnoremap("<leader>wl", "<cmd>wincmd l<CR>", "Move window right")

nnoremap("<leader>w+", "<cmd>vertical resize +5<CR>", "Increase window size")
nnoremap("<leader>w-", "<cmd>vertical resize -5<CR>", "Decrease window size")
