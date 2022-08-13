vim.g.vimspector_enable_mappings = "HUMAN"
vim.g.vimspector_isntall_gadgets = { "vscode-js-debug" }

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
