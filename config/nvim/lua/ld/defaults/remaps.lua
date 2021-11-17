-- reload
nnoremap('<leader><CR>', '<cmd>lua reload()<CR>', 'editor', 'reload', 'Reloads configuration')

-- toggle spellcapcheck
nnoremap('<leader>vt', '<cmd>setlocal spell! spelllang=en_us<CR>', "editor", 'toggle_spell_check', 'Toggle spell check')

-- move up/down faster 
nnoremap('J', '5j', 'remap', 'remap_move_down_fast_normal_mode', 'Move down faster')
nnoremap('K', '5k', 'remap', 'remap_move_up_fast_normal_mode', 'Move up faster')
vnoremap('J', '5j', 'remap', 'remap_move_down_fast_visual_mode', 'Move down faster visual mode')
vnoremap('K', '5k', 'remap', 'remap_move_up_fast_visual_mode', 'Move up faster visual mode')

-- Y should yank until end of line similar to D and C
nnoremap('Y', 'y$', 'remap', 'remap_yank_to_end_of_line', 'Yank to end of line')

-- deletes in visual
vnoremap('X', '"_d', 'remap', 'remap_deletes_on_visual', 'Deletes on visual')

-- when going to next search, we center screen
nnoremap('n', 'nzzzv', 'remap', 'remap_go_next_search', 'When going to next search, we center screen')
nnoremap('N', 'Nzzzv', 'remap', 'remap_go_previous_serach', 'When going to previous search, we center screen')

-- navigate quick fix
nnoremap(']q', ':cnext<CR>', 'remap', 'remap_next_quickfix', 'Navigate to next quickfix')
nnoremap('[q', ':cprev<CR>', 'remap', 'remap_previous_quickfix', 'Navigate to previous quickfix')

-- navigate command mode autocomplete
cnoremap('<C-j>', '<C-n>', 'remap', 'remap_next_cmd_suggestion', 'Select next command mode suggestion')
cnoremap('<C-k>', '<C-p>', 'remap', 'remap_previous_cmd_suggestion', 'Select previous command mode suggestion')

-- maps c-n / c-t to navigate while searching with /
vim.api.nvim_exec([[
cnoremap <expr> <c-n> getcmdtype() =~ '[\/?]' ? '<c-g>' : '<c-n>'
cnoremap <expr> <c-p> getcmdtype() =~ '[\/?]' ? '<c-t>' : '<c-p>'
]], false)

-- save buffer
nnoremap('<leader><leader>', '<cmd>write<CR>', 'remap', 'remap_save_current_buffer', 'save current buffer')

-- editing remaps
nnoremap('<leader>ej', '<cmd>join<CR>', 'remap', 'remap_join_lines', 'join 2 lines')

-- Undo break points
inoremap(',', ',<C-g>u', 'remap', 'remap_comma_undo_break_point', 'add undo break point after ,')
inoremap('.', '.<C-g>u', 'remap', 'remap_dot_undo_break_point', 'add undo break point after .')
inoremap('?', '?<C-g>u', 'remap', 'remap_question_mark_undo_break_point', 'add undo break point after ?')
inoremap('[', '[<C-g>u', 'remap', 'remap_open_bracket_undo_break_point', 'add undo break point after [')
inoremap(']', ']<C-g>u', 'remap', 'remap_close_bracket_undo_break_point', 'add undo break point after ]')
inoremap('{', '{<C-g>u', 'remap', 'remap_open_curly bracket_undo_break_point', 'add undo break point after {')
inoremap('}', '}<C-g>u', 'remap', 'remap_close_curly bracket_undo_break_point', 'add undo break point after }')

-- Moving text up and down youtube https://youtu.be/hSHATqh8svM
nnoremap('<A-j>', ':m .+1<CR>==', 'remap', 'remap_move_line_down_normal_mode', 'Move current line down')
nnoremap('<A-k>', ':m .-2<CR>==', 'remap', 'remap_move_line_up_normal_mode', 'Move current line up')
vnoremap('<A-j>', ":m '>+1<CR>gv=gv", 'remap', 'remap_move_selection_down', 'Move current selection down')
vnoremap('<A-k>', ":m '<-2<CR>gv=gv", 'remap', 'remap_move_selection_up', 'Move current selection up')
-- inoremap('<A-j>', '<esc>:m .+1<CR>==', 'remap', 'remap_move_line_down_insert_mode', 'Move current line down (Insert mode)')
-- inoremap('<A-k>', '<esc>:m .-2<CR>==', 'remap', 'remap_move_line_up_insert_mode', 'Move current line up (Insert mode)')
