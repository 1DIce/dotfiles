nnoremap('<leader><leader>h', "<cmd>lua require('harpoon.ui').nav_file(1)<CR>",
         'harpoon', 'harpoon_first', 'Jump to first harpoon file')
nnoremap('<leader><leader>j', "<cmd>lua require('harpoon.ui').nav_file(2)<CR>",
         'harpoon', 'harpoon_second', 'Jump to second harpoon file')
nnoremap('<leader><leader>k', "<cmd>lua require('harpoon.ui').nav_file(3)<CR>",
         'harpoon', 'harpoon_third', 'Jump to third harpoon file')
nnoremap('<leader><leader>l', "<cmd>lua require('harpoon.ui').nav_file(4)<CR>",
         'harpoon', 'harpoon_forth', 'Jump to forth harpoon file')
nnoremap('<leader><leader>f',
         "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", 'harpoon',
         'harpoon_toogle_quick_ui', 'harpoon toggle quick menu ui')
nnoremap('<leader><leader>g', "<cmd>lua require('harpoon.mark').add_file()<CR>",
         'harpoon', 'harpoon_add_file', 'Add file to Harpoon')
