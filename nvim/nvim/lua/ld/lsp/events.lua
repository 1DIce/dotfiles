local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

-- addEventListener('show diagnostic popup on cursor hold',
--                  {'CursorHold <buffer>'}, function()
--     vim.diagnostic.open_float({show_header = false})
-- end)

local M = {}

M.document_highlight_under_cursor = function()
  vim.cmd([[
  augroup DocumentHighlight
    autocmd! * <buffer>
    autocmd CursorHold  <buffer> :lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved,InsertEnter <buffer> :lua vim.lsp.buf.clear_references()
  augroup END
  ]])
end

-- Organize typescript imports on save
vim.cmd(
    [[autocmd BufWritePre *.ts :lua require('ld.lsp.functions').format_organize_typescript() ]])
-- Format file on save 
vim.cmd(
    [[autocmd BufWritePre *.html,*.js,*.less,*.json,*.scss,*.css :Prettier ]])
vim.cmd([[autocmd BufWritePre *.lua,*.sh :lua vim.lsp.buf.formatting_sync() ]])

return M

