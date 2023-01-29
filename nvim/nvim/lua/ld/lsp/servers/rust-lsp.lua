local rt = require("rust-tools")

M = {}

local extension_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension"
local codelldb_path = extension_path .. "/adapter/codelldb"
-- The path is only valid on linux!
local liblldb_path = extension_path .. "/lldb/lib/liblldb.so"

function M.setup(on_attach, capabilities)
  rt.setup({
    server = {
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
      end,
      dap = {
        adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
      },
    },
  })
end

return M
