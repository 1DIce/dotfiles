nnoremap("<leader>fp", "<cmd>Telescope projects<CR>", "Projects")

nnoremap("<leader>fl",
    "<cmd>lua require('ld.plugins.telescope.functions').live_grep_raw()<CR>",
    "Live grep")
vnoremap("<leader>fl",
    "<cmd>lua require('ld.plugins.telescope.functions').live_grep_raw({},'v')<CR>",
    "Live grep visual")
nnoremap("<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<CR>",
    "Find files")
nnoremap("<C-p>", "<cmd>lua require('fzf-lua').files()<CR>", "Find files")
vnoremap("<leader>fv", "<cmd>lua require('fzf-lua').grep_visual()<CR>",
    "Find visual selection")
nnoremap("<leader>fg", "<cmd>lua require('telescope.builtin').git_files()<CR>",
    "Find git files")
nnoremap("<leader>fc", "<cmd>lua require('telescope.builtin').git_status()<CR>",
    "Find git files")

nnoremap("<leader>fs",
    "<cmd>lua require('ld.plugins.telescope.functions').live_grep_raw({default_text = vim.fn.expand('<cword>')})<CR>",
    "Find string under cursor")

nnoremap("<leader>fm",
    "<cmd>lua require('ld.plugins.telescope.functions').find_files_angular_material()<CR>",
    "Search angular material source code")

nnoremap("<leader>vs",
    "<cmd>lua require('ld.plugins.telescope.functions').search_config()<CR>",
    "Search neovim config")
nnoremap("<leader>vh", "<cmd>lua require('telescope.builtin').help_tags()<CR>",
    "Search vim help tags")
nnoremap("<leader>vch",
    "<cmd>lua require('telescope.builtin').command_history()<CR>",
    "Search command history")
nnoremap("<leader>vcl", "<cmd>lua require('telescope.builtin').commands()<CR>",
    "Search commands")
nnoremap("<leader>vr", "<cmd>lua require('telescope.builtin').registers()<CR>",
    "Search registers")
nnoremap("<leader>vk", "<cmd>lua require('telescope.builtin').keymaps()<CR>",
    "Search keymaps")
nnoremap("<leader>vd", "<cmd>Telescope neoclip<CR>",
    "Search default register history")

nnoremap("<leader>bf",
    "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>",
    "Search current buffer")

nnoremap("<leader>bc",
    "<cmd>lua require('telescope.builtin').git_bcommits()<CR>",
    "Search buffer git commits")

nnoremap("<leader>bl",
    "<cmd>lua require('ld.plugins.telescope.functions').buffers()<CR>",
    "List open buffers")

nnoremap("<leader>fo",
    "<cmd>lua require('ld.plugins.telescope.functions').file_browser_home()<CR>",
    "Open file browser in $HOME")
