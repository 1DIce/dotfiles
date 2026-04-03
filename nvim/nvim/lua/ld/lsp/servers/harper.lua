local M = {}

function M.setup()
  return {
    cmd = { "harper-ls", "--stdio" },
    filetypes = { "markdown", "text", "tex", "gitcommit" },
    settings = {
      ["harper-ls"] = {
        diagnosticSeverity = "hint",
        dialect = "American",
      },
    },
    single_file_support = true,
  }
end

return M
