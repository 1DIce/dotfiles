
    nnoremap( '<leader>lt',
                   '<cmd>lua require(\'telescope\').extensions.coc.workspace_symbols({default_text="\'class | \'interface ", file_ignore_patterns={"%.spec.ts","node_modules"}})<CR>',
                   'lsp', 'lsp_workspace_type_definitions', 'Workspace type defintions')

    nnoremap( '<leader>lc',
                   '<cmd>lua require(\'telescope\').extensions.coc.workspace_symbols({default_text="\'variable ", file_ignore_patterns={"%.spec.ts","^e2e/","node_modules"}})<CR>',
                   'lsp', 'lsp_workspace_constants_definitions', 'Workspace constant defintions')
    nnoremap( '<leader>lf',
                   '<cmd>lua require(\'telescope\').extensions.coc.workspace_symbols({default_text="\'function ", file_ignore_patterns={"%.spec.ts","^e2e/","node_modules"}})<CR>',
                   'lsp', 'lsp_workspace_function definitions', 'Workspace function defintions')
    nnoremap( '<leader>lp',
                   '<cmd>lua require(\'telescope.builtin\').lsp_dynamic_workspace_symbols({symbols={"property"}, file_ignore_patterns={"%.spec.ts","^e2e/","node_modules"}})<CR>',
                   'lsp', 'lsp_workspace_property_definitions', 'Workspace property defintions')

    -- search for symbols in current buffer
    nnoremap( '<leader>bs', "<cmd>lua require(\'telescope\').extensions.coc.document_symbols({})<CR>", 'lsp',
                   'telescope_lsp_document_symbols', 'Search document symbols')


-- find references
  nnoremap( '<leader>lu', '<cmd>lua require(\'telescope\').extensions.coc.references({})<CR>', 'lsp',
                 'lsp_references', 'Show references')



-- go to definition




-- Use tab for trigger completion with characters ahead and navigate.
-- NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
-- other plugin before putting this into your config.
-- inoremap <silent><expr> <TAB>
--       \ pumvisible() ? "\<C-n>" :
--       \ <SID>check_back_space() ? "\<TAB>" :
--       \ coc#refresh()
-- inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
-- function! s:check_back_space() abort
--   let col = col('.') - 1
--   return !col || getline('.')[col - 1]  =~# '\s'
-- endfunction
-- Use <c-space> to trigger completion.
-- inoremap <silent><expr> <c-space> coc#refresh()
-- lMake <CR> auto-select the first completion item and notify coc.nvim to
-- format on enter, <cr> could be remapped by other vim plugin
-- inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
--                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
-- nmap <silent> [g <Plug>(coc-diagnostic-prev)
-- nmap <silent> ]g <Plug>(coc-diagnostic-next)
-- GoTo code navigation.
-- nmap <silent> gd <Plug>(coc-definition)
-- nmap <silent> gy <Plug>(coc-type-definition)
-- nmap <silent> gi <Plug>(coc-implementation)
-- nmap <silent> gr <Plug>(coc-references)
-- Use K to show documentation in preview window.
-- nnoremap <silent> K :call <SID>show_documentation()<CR>
-- function! s:show_documentation()
--   if (index(['vim','help'], &filetype) >= 0)
--     execute 'h '.expand('<cword>')
--   elseif (coc#rpc#ready())
--     call CocActionAsync('doHover')
--   else
--     execute '!' . &keywordprg . " " . expand('<cword>')
--   endif
-- endfunction
-- Highlight the symbol and its references when holding the cursor.
-- autocmd CursorHold * silent call CocActionAsync('highlight')
--
-- " Symbol renaming.
-- nmap <leader>rn <Plug>(coc-rename)
-- " Formatting selected code.
-- xmap <leader>f  <Plug>(coc-format-selected)
-- nmap <leader>f  <Plug>(coc-format-selected)
-- augroup mygroup
--   autocmd!
--   " Setup formatexpr specified filetype(s).
--   autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
--   " Update signature help on jump placeholder.
--   autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
-- augroup end
-- " Applying codeAction to the selected region.
-- " Example: `<leader>aap` for current paragraph
-- xmap <leader>a  <Plug>(coc-codeaction-selected)
-- nmap <leader>a  <Plug>(coc-codeaction-selected)
-- " Remap keys for applying codeAction to the current buffer.
-- nmap <leader>ac  <Plug>(coc-codeaction)
-- " Apply AutoFix to problem on the current line.
-- nmap <leader>qf  <Plug>(coc-fix-current)
-- " Map function and class text objects
-- " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
-- xmap if <Plug>(coc-funcobj-i)
-- omap if <Plug>(coc-funcobj-i)
-- xmap af <Plug>(coc-funcobj-a)
-- omap af <Plug>(coc-funcobj-a)
-- xmap ic <Plug>(coc-classobj-i)
-- omap ic <Plug>(coc-classobj-i)
-- xmap ac <Plug>(coc-classobj-a)
-- omap ac <Plug>(coc-classobj-a)
-- " Remap <C-f> and <C-b> for scroll float windows/popups.
-- if has('nvim-0.4.0') || has('patch-8.2.0750')
--   nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
--   nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
--   inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
--   inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
--   vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
--   vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
-- endif
-- " Use CTRL-S for selections ranges.
-- " Requires 'textDocument/selectionRange' support of language server.
-- nmap <silent> <C-s> <Plug>(coc-range-select)
-- xmap <silent> <C-s> <Plug>(coc-range-select)
-- " Add `:Format` command to format current buffer.
-- command! -nargs=0 Format :call CocAction('format')
-- " Add `:Fold` command to fold current buffer.
-- command! -nargs=? Fold :call     CocAction('fold', <f-args>)
-- " Add `:OR` command for organize imports of the current buffer.
-- command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
-- " Add (Neo)Vim's native statusline support.
-- " NOTE: Please see `:h coc-status` for integrations with external plugins that
-- " provide custom statusline: lightline.vim, vim-airline.
-- set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
-- " Mappings for CoCList
-- " Show all diagnostics.
-- nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
-- " Manage extensions.
-- nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
-- " Show commands.
-- nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
-- " Find symbol of current document.
-- nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
-- " Search workspace symbols.
-- nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
-- " Do default action for next item.
-- nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
-- " Do default action for previous item.
-- nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
-- " Resume latest coc list.
-- nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
