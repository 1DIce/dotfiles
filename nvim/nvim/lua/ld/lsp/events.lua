local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

-- addEventListener('show diagnostic popup on cursor hold',
--                  {'CursorHold <buffer>'}, function()
--     vim.diagnostic.open_float({show_header = false})
-- end)

vim.api
    .nvim_command [[autocmd CursorHold  *.ts,*.lua :lua vim.lsp.buf.document_highlight()]]
-- vim.api
--     .nvim_command [[autocmd CursorHoldI *.ts,*.lua :lua vim.lsp.buf.document_highlight()]]
vim.api
    .nvim_command [[autocmd CursorMoved,InsertEnter *.ts,*.lua :lua vim.lsp.buf.clear_references()]]

if filetype == 'rust' then
    vim.cmd(
        [[autocmd BufEnter,BufWritePost <buffer> :lua require('lsp_extensions.inlay_hints').request { ]] ..
            [[aligned = true, prefix = " » " ]] .. [[} ]])
end

-- Organize typescript imports on save
vim.cmd(
    [[autocmd BufWritePre *.ts :lua require('ld.lsp.functions').format_organize_typescript() ]])
-- Format file on save 

vim.cmd([[autocmd BufWritePre *.html,*.js,*.less,*.json,*.scss :Prettier ]])
vim.cmd([[autocmd BufWritePre *.lua :lua vim.lsp.buf.formatting_sync() ]])


