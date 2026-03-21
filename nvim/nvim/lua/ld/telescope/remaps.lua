nnoremap("<leader>fp", "<cmd>Telescope projects<CR>", "Projects")

-- nnoremap(
--   "<leader>fl",
--   "<cmd>lua require('ld.telescope.functions').live_grep_raw()<CR>",
--   "Live grep"
-- )
-- vnoremap(
--   "<leader>fl",
--   "<cmd>lua require('ld.telescope.functions').live_grep_raw({},'v')<CR>",
--   "Live grep visual"
-- )
nnoremap("<leader>fl", "<cmd>lua require('grug-far').open()<CR>", "Live grep")
vnoremap(
  "<leader>fl",
  "<cmd>lua require('grug-far').with_visual_selection()<CR>",
  "Live grep visual"
)
nnoremap("<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<CR>", "Find files")
nnoremap("<C-p>", "<cmd>lua require('ld.fzf').files()<CR>", "Find files")
vnoremap("<leader>fv", "<cmd>lua require('fzf-lua').grep_visual()<CR>", "Find visual selection")
nnoremap(
  "<leader>fg",
  "<cmd>lua require('ld.telescope.functions').git_files()<CR>",
  "Find git files"
)
vnoremap(
  "<leader>fg",
  "<cmd>lua require('ld.telescope.functions').git_files()<CR>",
  "Find git files"
)
nnoremap("<leader>fc", "<cmd>lua require('telescope.builtin').git_status()<CR>", "Find git files")

nnoremap(
  "<leader>fs",
  "<cmd>lua require('ld.telescope.functions').live_grep_raw({default_text = vim.fn.expand('<cword>')})<CR>",
  "Find string under cursor"
)

nnoremap(
  "<leader>fm",
  "<cmd>lua require('ld.telescope.functions').find_files_angular_material()<CR>",
  "Search angular material source code"
)

nnoremap(
  "<leader>vs",
  "<cmd>lua require('ld.telescope.functions').search_config()<CR>",
  "Search neovim config"
)
nnoremap("<leader>vh", "<cmd>lua Snacks.picker.help()<CR>", "Search vim help tags")
nnoremap("<leader>vch", "<cmd>lua Snacks.picker.command_history()<CR>", "Search command history")
nnoremap("<leader>vcl", "<cmd>lua Snacks.picker.commands()<CR>", "Search commands")
nnoremap("<leader>vr", "<cmd>lua Snacks.picker.registers()<CR>", "Search registers")
nnoremap("<leader>vk", "<cmd>lua Snacks.picker.keymaps()<CR>", "Search keymaps")

nnoremap(
  "<leader>bf",
  "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>",
  "Search current buffer"
)

nnoremap(
  "<leader>bc",
  "<cmd>lua require('telescope.builtin').git_bcommits()<CR>",
  "Search buffer git commits"
)

nnoremap("<leader>bl", "<cmd>lua Snacks.picker.buffers()<CR>", "List open buffers")

nnoremap(
  "<leader>fo",
  "<cmd>lua require('ld.telescope.functions').file_browser_home()<CR>",
  "Open file browser in $HOME"
)

nnoremap(
  "<leader>lt",
  "<cmd>lua require('ld.picker.coding-flow').workspace_public_types()<CR>",
  "Workspace type defintions"
)
nnoremap(
  "<leader>lv",
  "<cmd>lua require('ld.picker.coding-flow').workspace_public_variables()<CR>",
  "Workspace variable defintions"
)
nnoremap(
  "<leader>lf",
  "<cmd>lua require('ld.picker.coding-flow').workspace_public_functions()<CR>",
  "Workspace function defintions"
)
