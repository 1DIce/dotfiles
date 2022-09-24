local rt = require("rust-tools")

M = {}

function M.setup(on_attach, capabilities)
  rt.setup({
    server = {
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
      end,
    },
  })
end

return M
