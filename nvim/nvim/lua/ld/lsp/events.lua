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
vim.cmd([[autocmd BufWritePre *.html,*.js,*.yml,*.yaml,*.less,*.json,*.scss,*.css :Prettier ]])
vim.cmd([[autocmd BufWritePre *.lua,*.sh,*.go :lua vim.lsp.buf.formatting_sync() ]])

return M
