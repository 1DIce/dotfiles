nnoremap('<leader>jj', "<cmd>lua require('harpoon.ui').nav_file(1)<CR>",
         'harpoon', 'harpoon_first', 'Jump to first harpoon file')
nnoremap('<leader>jf', "<cmd>lua require('harpoon.ui').nav_file(2)<CR>",
         'harpoon', 'harpoon_second', 'Jump to second harpoon file')
nnoremap('<leader>jk', "<cmd>lua require('harpoon.ui').nav_file(3)<CR>",
         'harpoon', 'harpoon_third', 'Jump to third harpoon file')
nnoremap('<leader>jg', "<cmd>lua require('harpoon.ui').nav_file(4)<CR>",
         'harpoon', 'harpoon_forth', 'Jump to forth harpoon file')
nnoremap('<leader>jhc',
         "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", 'harpoon',
         'harpoon_toogle_quick_ui', 'harpoon toggle quick menu ui')
nnoremap('<leader>jha', "<cmd>lua require('harpoon.mark').add_file()<CR>",
         'harpoon', 'harpoon_add_file', 'Add file to Harpoon')
