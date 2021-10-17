-- reload
nnoremap('<leader><CR>', '<cmd>lua reload()<CR>', 'editor', 'reload', 'Reloads configuration')

-- move upper/down on visual
vnoremap('K', '<cmd>m "<-2<CR>gv=gv"', 'remap', 'remap_move_upper_on_visual', 'Move upper on visual')
vnoremap('J', '<cmd>m ">+1<CR>gv=gv"', 'remap', 'remap_move_down_on_visual', 'Move down on visual')

-- move up/down 
nnoremap('J', '5j', 'remap', 'remap_move_down_fast', 'Move down faster')
nnoremap('K', '5k', 'remap', 'remap_move_up_fast', 'Move up faster')

-- deletes in visual
vnoremap('X', '"_d', 'remap', 'remap_deletes_on_visual', 'Deletes on visual')

-- when going to next search, we center screen
nnoremap('n', 'nzzzv', 'remap', 'remap_go_next_search', 'When going to next search, we center screen')
nnoremap('N', 'Nzzzv', 'remap', 'remap_go_previous_serach', 'When going to previous search, we center screen')

-- navigate quick fix
nnoremap(']q', ':cnext<CR>', 'remap', 'remap_next_quickfix', 'Navigate to next quickfix')
nnoremap('[q', ':cprev<CR>', 'remap', 'remap_previous_quickfix', 'Navigate to previous quickfix')

-- maps c-n / c-t to navigate while searching with /
vim.api.nvim_exec(
[[
cnoremap <expr> <c-n> getcmdtype() =~ '[\/?]' ? '<c-g>' : '<c-n>'
cnoremap <expr> <c-p> getcmdtype() =~ '[\/?]' ? '<c-t>' : '<c-p>'
]], false)


-- editing remaps
nnoremap('<leader>ej', 'gJ', 'remap', 'remap_join_lines', 'join 2 lines')
