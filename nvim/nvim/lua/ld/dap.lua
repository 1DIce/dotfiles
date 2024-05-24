local dapui = require("dapui")
local dap = require("dap")
local utils = require("ld.utils.functions")

local function get_chrome_debugger_path()
  if utils.is_windows() then
    return vim.fn.stdpath("data")
      .. "\\mason\\packages\\chrome-debug-adapter\\out\\src\\chromeDebug.js"
  else
    return vim.fn.stdpath("data") .. "/mason/bin/chrome-debug-adapter"
  end
end

dap.adapters.chrome = {
  type = "executable",
  command = "node",
  args = { get_chrome_debugger_path() },
}

dap.configurations.typescript = { -- change this to javascript if needed
  {
    name = "Chrome",
    type = "chrome",
    request = "attach",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    port = 9222,
    webRoot = "${workspaceFolder}",
  },
  {
    name = "Karma",
    type = "chrome",
    request = "attach",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    port = 9222,
    webRoot = "${workspaceFolder}",
    url = "http://localhost:9876/debug.html",
    pathMapping = {
      ["/_karma_webpack_"] = "${workspaceFolder}",
    },
  },
}

vim.cmd([[
    nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>
    nnoremap <silent> <F6> <Cmd>lua require'dap'.step_over()<CR>
    nnoremap <silent> <F7> <Cmd>lua require'dap'.step_into()<CR>
    nnoremap <silent> <F8> <Cmd>lua require'dap'.step_out()<CR>
    nnoremap <silent> <Leader>db <Cmd>lua require'dap'.toggle_breakpoint()<CR>
    nnoremap <silent> <Leader>dB <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
    nnoremap <silent> <Leader>dp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
    nnoremap <silent> <Leader>dr <Cmd>lua require'dap'.repl.open()<CR>
    nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.run_last()<CR>
]])

dapui.setup({})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
