vnoremap("<leader>re",
    [[ <Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
    "Extract Function")

vnoremap("<leader>rf",
    [[ <Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
    "Extact Function to file")
