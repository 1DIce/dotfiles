local M = {}

function M.lsp_buffer_symbols()
  Snacks.picker.lsp_symbols({
    filter = {
      default = {
        "Class",
        "Enum",
        "Function",
        "Interface",
        "Namespace",
        "Package",
        "Property",
        "Struct",
        "Trait",
      },
      markdown = true,
      help = true,
      rust = {
        "Function",
        "Method",
        "Property",
        "Variable",
        -- "Constant",
        "Enum",
        "Interface",
        -- "Field",
        "Struct",
      },
      python = { "Function", "Class", "Method", "Enum", "Interface" },
      lua = {
        "Class",
        "Enum",
        "Function",
        "Interface",
        "Method",
        "Module",
        "Namespace",
        -- "Package", -- remove package since luals uses it for control flow structures
        "Struct",
        "Trait",
      },
    },
  })
end

return M
