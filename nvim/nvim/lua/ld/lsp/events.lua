local M = {}

M.document_highlight_under_cursor = function()
  vim.cmd([[
  augroup DocumentHighlight
    autocmd! * <buffer>
    autocmd CursorHold  <buffer> :silent! lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved,InsertEnter <buffer> :silent! lua vim.lsp.buf.clear_references()
  augroup END
  ]])
end

-- Organize typescript imports on save
vim.cmd([[autocmd BufWritePre *.ts :lua require('ld.lsp.functions').format_organize_typescript() ]])
-- Format file on save
vim.cmd(
  -- using prettierd from null-ls for formatting
  [[autocmd BufWritePre *.html,*.js,*.yml,*.yaml,*.less,*.json,*.jsonc,*.scss,*.css,*.lua,*.cpp,*.h,*.rs :lua vim.lsp.buf.format({async = false}) ]]
)

return M
