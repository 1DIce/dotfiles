nnoremap('<leader>fp', "<cmd>Telescope projects<CR>", 'telescope', 'telescope_projects', 'Projects')
nnoremap('<leader>fl', "<cmd>lua require('telescope.builtin').live_grep()<CR>", 'telescope', 'telescope_live_grep', 'Live grep')
nnoremap('<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<CR>", 'telescope', 'telescope_files', 'Find files')
nnoremap('<leader>pg', "<cmd>lua require('telescope.builtin').git_files()<CR>", 'telescope', 'telescope_git_files', 'Find git files')
nnoremap('<leader>fc', "<cmd>lua require('ld.plugins.telescope.functions').search_config()<CR>", 'telescope', 'telescope_search_config', 'Search neovim config')

nnoremap('<leader>/h', "<cmd>lua require('telescope.builtin').command_history()<CR>", 'telescope', 'telescope_command_history', 'Search command history')
nnoremap('<leader>/c', "<cmd>lua require('telescope.builtin').commands()<CR>", 'telescope', 'telescope_commands', 'Search commands')
nnoremap('<leader>/r', "<cmd>lua require('telescope.builtin').registers()<CR>", 'telescope', 'telescope_registers', 'Search registers')
nnoremap('<leader>fk', "<cmd>lua require('telescope.builtin').keymaps()<CR>", 'telescope', 'telescope_keymaps', 'Search keymaps')

nnoremap('<leader>bt', "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>", 'telescope', 'telescope_current_buffer_fuzzy_find', 'Search current buffer')
nnoremap('<leader>bc', "<cmd>lua require('telescope.builtin').git_bcommits()<CR>", 'telescope', 'telescope_git_bcommits', 'Search buffer git commits')
nnoremap('<leader>bl', "<cmd>lua require('telescope.builtin').buffers()<CR>", 'telescope', 'telescope_buffers', 'List open buffers')
