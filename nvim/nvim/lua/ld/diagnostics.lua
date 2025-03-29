local default_config = {
  virtual_text = { severity = vim.diagnostic.severity.ERROR },
  virtual_lines = false,
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
}

vim.diagnostic.config(default_config)

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

vim.keymap.set("n", "<leader>ev", function()
  if vim.diagnostic.config().virtual_lines == false then
    vim.diagnostic.config({ virtual_lines = true, virtual_text = false })
  else
    vim.diagnostic.config(default_config)
  end
end, { desc = "Toggle virtual lines diagnostics" })

nnoremap("<leader>ej", "<cmd>lua vim.diagnostic.goto_next()<CR>", "next diagnostic")
nnoremap("<leader>ek", "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Previous diagnostic")
