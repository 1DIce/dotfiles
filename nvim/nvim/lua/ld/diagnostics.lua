local default_config = {
  virtual_text = { current_line = true },
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
vim.keymap.set("n", "<leader>eq", function()
  vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Send Errors to qflist" })

vim.keymap.set("n", "<leader>eh", function()
  vim.diagnostic.open_float({
    suffix = function(d)
      if d.source then
        return (" (%s)"):format(d.source), ""
      else
        return "", ""
      end
    end,
    border = "rounded",
  })
end, { desc = "Show line diagnostics" })

vim.keymap.set("n", "<leader>ev", function()
  local vl = vim.diagnostic.config().virtual_lines
  if vl and vl ~= false then
    vim.diagnostic.config({ virtual_lines = false, virtual_text = { current_line = true } })
  else
    vim.diagnostic.config({ virtual_lines = true, virtual_text = false })
  end
end, { desc = "Toggle virtual lines diagnostics" })

nnoremap("<leader>ej", "<cmd>lua vim.diagnostic.goto_next()<CR>", "next diagnostic")
nnoremap("<leader>ek", "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Previous diagnostic")
