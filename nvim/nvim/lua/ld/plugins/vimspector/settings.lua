-- let g:vimspector_enable_mappings = 'HUMAN'nmap <leader>vl :call vimspector#Launch()<CR>
-- nmap <leader>vr :VimspectorReset<CR>
-- nmap <leader>ve :VimspectorEval
-- nmap <leader>vw :VimspectorWatch
-- nmap <leader>vo :VimspectorShowOutput
-- nmap <leader>vi <Plug>VimspectorBalloonEval
-- xmap <leader>vi <Plug>VimspectorBalloonEvallet g:vimspector_install_gadgets = [ 'debugpy', 'vscode-go', 'CodeLLDB', 'vscode-node-debug2' ]
vim.g.vimspector_enable_mappings = "HUMAN"
vim.g.vimspector_isntall_gadgets = {"vscode-js-debug"}

vim.cmd([[
:command VimspectorChrome call vimspector#LaunchWithConfigurations({
               \  "attach": {
               \    "adapter": "chrome",
               \    "configuration": {
               \      "request": "attach",
               \      "port": "9222",
               \      "webRoot": getcwd()
               \    }
               \  }
               \})
]])
