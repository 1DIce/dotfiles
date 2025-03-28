vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  pattern = "*",
  callback = function()
    vim.hl.on_yank({ timeout = 500 })
  end,
})
