nmap("<leader>gs", "<cmd>G<CR>", "git", "git_status", "Git status")
nmap("<leader>gf", "<cmd>diffget //2<CR>", "git", "git_diffget_2",
    "TODO diffget 2")
nmap("<leader>gj", "<cmd>diffget //3<CR>", "git", "git_diffget_3",
    "TODO diffget 3")
nmap("<leader>gd", "<cmd>Gdiffsplit<CR>", "git", "git_diff_split",
    "Shows diff with git")
nmap("<leader>gb", "<cmd>Git blame<CR>", "git", "git_blame", "Blame")
nmap("<leader>gh", "<cmd>0Gclog!<CR>", "git", "git_navigate_history",
    "Navigate history")
