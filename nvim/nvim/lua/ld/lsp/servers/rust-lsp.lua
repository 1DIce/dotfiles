M = {}

local extension_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension"
local codelldb_path = extension_path .. "/adapter/codelldb"
-- The path is only valid on linux!
local liblldb_path = extension_path .. "/lldb/lib/liblldb.so"

function M.setup()
  vim.g.rustaceanvim = {
    tools = {
      hover_actions = {
        replace_builtin_hover = false,
      },
    },
    server = {
      dap = {
        adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path),
      },
    },
  }
end

return M
