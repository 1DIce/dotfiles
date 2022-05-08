vim.api.nvim_create_autocmd({"TextYankPost"}, {
  pattern = "*",
  callback = function() require'vim.highlight'.on_yank {timeout = 500} end
})
