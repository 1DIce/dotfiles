vim.diagnostic.config({
  virtual_text = { severity = vim.diagnostic.severity.ERROR },
  underline = true,
  update_in_insert = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
})

nnoremap(
  "<leader>el",
  "<cmd>lua require('telescope.builtin').diagnostics()<CR>",
  "Show workspace diagnostics"
)
nnoremap("<leader>eq", "<cmd>lua vim.diagnostic.setqflist()", "Show workspace diagnostics")

vim.keymap.set("n", "<leader>eh", function()
  vim.diagnostic.open_float({
    suffix = function(d)
      return (" (%s)"):format(d.source)
    end,
    border = "rounded",
  })
end, { desc = "Show line diagnostics" })

nnoremap("<leader>ej", "<cmd>lua vim.diagnostic.goto_next()<CR>", "next diagnostic")
nnoremap("<leader>ek", "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Previous diagnostic")
