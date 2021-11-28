local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

addEventListener('show diagnostic popup on cursor hold', {'CursorHold <buffer>'},
                 function() vim.lsp.diagnostic.show_line_diagnostics({show_header = false}) end)

if filetype == 'rust' then
  vim.cmd([[autocmd BufEnter,BufWritePost <buffer> :lua require('lsp_extensions.inlay_hints').request { ]] ..
              [[aligned = true, prefix = " » " ]] .. [[} ]])
end

-- Organize typescript imports on save
vim.cmd([[autocmd BufWritePre *.ts :lua require('ld.lsp.functions').format_organize_typescript() ]])
-- Format file on save 

vim.cmd([[autocmd BufWritePre *.html,*.js,*.less,*.json,*.lua,*.scss :lua vim.lsp.buf.formatting_sync() ]])
