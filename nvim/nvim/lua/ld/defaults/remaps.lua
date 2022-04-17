-- reload
nnoremap('<leader><CR>', '<cmd>lua reload()<CR>', 'editor', 'reload',
         'Reloads configuration')

-- toggle spellcapcheck
nnoremap('<leader>vt',
         '<cmd>setlocal spell! spelllang=en_us spelloptions=camel<CR>',
         "editor", 'toggle_spell_check', 'Toggle spell check')

-- Y should yank until end of line similar to D and C
nnoremap('Y', 'y$', 'remap', 'remap_yank_to_end_of_line', 'Yank to end of line')

-- do not replace register content when pasting in visual mode
vnoremap('p', 'pgvy', 'remap', 'remap_paste_in_visual_mode',
         'Paste does not replace register content')

-- deletes in visual
vnoremap('X', '"_d', 'remap', 'remap_deletes_on_visual', 'Deletes on visual')

-- when going to next search, we center screen
nnoremap('n', 'nzzzv', 'remap', 'remap_go_next_search',
         'When going to next search, we center screen')
nnoremap('N', 'Nzzzv', 'remap', 'remap_go_previous_serach',
         'When going to previous search, we center screen')

-- navigate quick fix
nnoremap('<leader>qo', ':copen<CR>', 'remap', 'remap_open_quickfix',
         'Open quickfix list')
nnoremap('<leader>qc', ':cclose<CR>', 'remap', 'remap_close_quickfix',
         'Close quickfix list')
nnoremap('<leader>qn', ':cnext<CR>', 'remap', 'remap_next_quickfix',
         'Navigate to next quickfix')
nnoremap('<leader>qp', ':cprev<CR>', 'remap', 'remap_previous_quickfix',
         'Navigate to previous quickfix')

-- navigate command mode autocomplete
cnoremap('<C-j>', '<C-n>', 'remap', 'remap_next_cmd_suggestion',
         'Select next command mode suggestion')
cnoremap('<C-k>', '<C-p>', 'remap', 'remap_previous_cmd_suggestion',
         'Select previous command mode suggestion')

-- maps c-n / c-t to navigate while searching with /
vim.api.nvim_exec([[
cnoremap <expr> <c-n> getcmdtype() =~ '[\/?]' ? '<c-g>' : '<c-n>'
cnoremap <expr> <c-p> getcmdtype() =~ '[\/?]' ? '<c-t>' : '<c-p>'
]], false)

-- save buffer
nnoremap('<leader><leader>s', '<cmd>write<CR>', 'remap',
         'remap_save_current_buffer', 'save current buffer')

-- editing remaps
nnoremap('<leader>ej', '<cmd>join<CR>', 'remap', 'remap_join_lines',
         'join 2 lines')

-- Undo break points
inoremap(',', ',<C-g>u', 'remap', 'remap_comma_undo_break_point',
         'add undo break point after ,')
inoremap('.', '.<C-g>u', 'remap', 'remap_dot_undo_break_point',
         'add undo break point after .')
inoremap('?', '?<C-g>u', 'remap', 'remap_question_mark_undo_break_point',
         'add undo break point after ?')
inoremap('[', '[<C-g>u', 'remap', 'remap_open_bracket_undo_break_point',
         'add undo break point after [')
inoremap(']', ']<C-g>u', 'remap', 'remap_close_bracket_undo_break_point',
         'add undo break point after ]')
inoremap('{', '{<C-g>u', 'remap', 'remap_open_curly bracket_undo_break_point',
         'add undo break point after {')
inoremap('}', '}<C-g>u', 'remap', 'remap_close_curly bracket_undo_break_point',
         'add undo break point after }')

-- Moving text up and down youtube https://youtu.be/hSHATqh8svM
nnoremap('<A-j>', ':m .+1<CR>==', 'remap', 'remap_move_line_down_normal_mode',
         'Move current line down')
nnoremap('<A-k>', ':m .-2<CR>==', 'remap', 'remap_move_line_up_normal_mode',
         'Move current line up')
vnoremap('<A-j>', ":m '>+1<CR>gv=gv", 'remap', 'remap_move_selection_down',
         'Move current selection down')
vnoremap('<A-k>', ":m '<-2<CR>gv=gv", 'remap', 'remap_move_selection_up',
         'Move current selection up')
-- inoremap('<A-j>', '<esc>:m .+1<CR>==', 'remap', 'remap_move_line_down_insert_mode', 'Move current line down (Insert mode)')
-- inoremap('<A-k>', '<esc>:m .-2<CR>==', 'remap', 'remap_move_line_up_insert_mode', 'Move current line up (Insert mode)')

-- terminal binginds
-- go to normal mode
tnoremap('<C-s>', "<C-\\><C-n>", 'remap', 'remap_terimal_enter_normal_mode',
         'Enter terminal normal mode')

tnoremap('<C-w>h', "<C-\\><C-n><C-w>h", 'remap', 'remap_terimal_switch_pane_h',
         'Terminal switch pane left')
tnoremap('<C-w>l', "<C-\\><C-n><C-w>l", 'remap', 'remap_terimal_switch_pane_l',
         'Terminal switch pane right')
tnoremap('<C-w>j', "<C-\\><C-n><C-w>j", 'remap', 'remap_terimal_switch_pane_j',
         'Terminal switch pane down')
tnoremap('<C-w>k', "<C-\\><C-n><C-w>k", 'remap', 'remap_terimal_switch_pane_k',
         'Terminal switch pane up')
