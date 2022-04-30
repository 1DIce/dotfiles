vim.api.nvim_create_autocmd({"TextYankPost"}, {
  pattern = "*",
  callback = function() require'vim.highlight'.on_yank {timeout = 500} end
})
vim.cmd([[au BufRead,BufNewFile *.jenkins   setfiletype Jenkinsfile]])
vim.cmd([[au BufRead,BufNewFile gitconfig*   setfiletype gitconfig]])
