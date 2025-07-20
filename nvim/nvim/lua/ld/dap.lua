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

vim.keymap.set("n", "<F5>", function()
  require("dap").continue()
end)
vim.keymap.set("n", "<F6>", function()
  require("dap").step_over()
end)
vim.keymap.set("n", "<F7>", function()
  require("dap").step_into()
end)
vim.keymap.set("n", "<F8>", function()
  require("dap").step_out()
end)
vim.keymap.set("n", "<Leader>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<Leader>dB", function()
  require("dap").set_breakpoint()
end, { desc = "Set breakpoint" })
vim.keymap.set("n", "<Leader>dp", function()
  require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, { desc = "Set breakpoint with msg" })
vim.keymap.set("n", "<Leader>dr", function()
  require("dap").repl.open()
end)
vim.keymap.set("n", "<Leader>dl", function()
  require("dap").run_last()
end, { desc = "Dap run last" })
vim.keymap.set({ "n", "v" }, "<Leader>dk", function()
  require("dap.ui.widgets").hover(nil, { border = "rounded" })
end, { desc = "Debug hover" })

dap.listeners.after.event_initialized["dapui_config"] = function()
  require("dap-view").open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  require("dap-view").close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  require("dap-view").close()
end
