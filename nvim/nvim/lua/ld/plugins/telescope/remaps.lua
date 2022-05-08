nnoremap("<leader>fp", "<cmd>Telescope projects<CR>", "telescope",
    "telescope_projects", "Projects")

nnoremap("<leader>fl",
    "<cmd>lua require('ld.plugins.telescope.functions').live_grep_raw()<CR>",
    "telescope", "telescope_live_grep", "Live grep")
vnoremap("<leader>fl",
    "<cmd>lua require('ld.plugins.telescope.functions').live_grep_raw({},'v')<CR>",
    "telescope", "telescope_live_grep_visual", "Live grep visual")
-- nnoremap('<leader>fl', "<cmd>lua require('telescope.builtin').live_grep()<CR>",
--          'telescope', 'telescope_live_grep', 'Live grep')
-- nnoremap('<leader>fl', "<cmd>lua require('fzf-lua').live_grep_native()<CR>",
--          'telescope', 'telescope_live_grep', 'Live grep')
nnoremap("<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<CR>",
    "telescope", "telescope_files", "Find files")
nnoremap("<C-p>", "<cmd>lua require('fzf-lua').files()<CR>", "telescope",
    "fzf_files", "Find files")
vnoremap("<leader>fv", "<cmd>lua require('fzf-lua').grep_visual()<CR>",
    "fzf_lua", "fzf_lua_grep_visuals", "Find visual selection")
nnoremap("<leader>fg", "<cmd>lua require('telescope.builtin').git_files()<CR>",
    "telescope", "telescope_git_files", "Find git files")
nnoremap("<leader>fc", "<cmd>lua require('telescope.builtin').git_status()<CR>",
    "telescope", "telescope_git_status", "Find git files")
-- nnoremap('<leader>fs', "<cmd>Telescope grep_string<CR>", 'telescope',
--          'telescope_grep_string', 'Find string under cursor')
nnoremap("<leader>fs",
    "<cmd>lua require('ld.plugins.telescope.functions').live_grep_raw({default_text = vim.fn.expand('<cword>')})<CR>",
    "telescope", "telescope_grep_string", "Find string under cursor")

nnoremap("<leader>fm",
    "<cmd>lua require('ld.plugins.telescope.functions').find_files_angular_material()<CR>",
    "telescope", "telescope_search_angular_material",
    "Search angular material source code")

nnoremap("<leader>vs",
    "<cmd>lua require('ld.plugins.telescope.functions').search_config()<CR>",
    "telescope", "telescope_search_config", "Search neovim config")
nnoremap("<leader>vh", "<cmd>lua require('telescope.builtin').help_tags()<CR>",
    "telescope", "telescope_help_tags", "Search vim help tags")
nnoremap("<leader>vch",
    "<cmd>lua require('telescope.builtin').command_history()<CR>", "telescope",
    "telescope_command_history", "Search command history")
nnoremap("<leader>vcl", "<cmd>lua require('telescope.builtin').commands()<CR>",
    "telescope", "telescope_commands", "Search commands")
nnoremap("<leader>vr", "<cmd>lua require('telescope.builtin').registers()<CR>",
    "telescope", "telescope_registers", "Search registers")
nnoremap("<leader>vk", "<cmd>lua require('telescope.builtin').keymaps()<CR>",
    "telescope", "telescope_keymaps", "Search keymaps")
nnoremap("<leader>vd", "<cmd>Telescope neoclip<CR>", "telescope",
    "telescope_default_register", "Search default register history")

nnoremap("<leader>bf",
    "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>",
    "telescope", "telescope_current_buffer_fuzzy_find", "Search current buffer")

nnoremap("<leader>bc",
    "<cmd>lua require('telescope.builtin').git_bcommits()<CR>", "telescope",
    "telescope_git_bcommits", "Search buffer git commits")

nnoremap("<leader>bl",
    "<cmd>lua require('ld.plugins.telescope.functions').buffers()<CR>",
    "telescope", "telescope_buffers", "List open buffers")

nnoremap("<leader>fo",
    "<cmd>lua require('ld.plugins.telescope.functions').file_browser_home()<CR>",
    "telescope", "telescope_file_browser_home", "Open file browser in $HOME")
