M = {}

local extension_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension"
local codelldb_path = extension_path .. "/adapter/codelldb"
-- The path is only valid on linux!
local liblldb_path = extension_path .. "/lldb/lib/liblldb.so"

function M.setup(on_attach, capabilities)
  vim.g.rustaceanvim = function()
    return {
      tools = {
        hover_actions = {
          { replace_builtin_hover = false },
        },
      },
      server = {
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
        end,
        dap = {
          adapter = require("rustaceanvim.config").get_codelldb_adapter(
            codelldb_path,
            liblldb_path
          ),
        },
      },
    }
  end
end

return M
