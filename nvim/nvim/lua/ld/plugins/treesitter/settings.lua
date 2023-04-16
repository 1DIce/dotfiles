local installer = require("nvim-treesitter.install")
local parsers = require("nvim-treesitter.parsers")
local parser_configs = parsers.get_parser_configs()
-- end neorgtreesitter
parser_configs.css.filetype_to_parsername = "less"
parser_configs.jsonc.filetype_to_parsername = "json"

parser_configs.angular = {
  install_info = {
    url = "https://github.com/shootex/tree-sitter-angular",
    files = { "src/parser.c" },
    branch = "main",
  },
}
if not parsers.has_parser("angular") then
  installer.update("angular")
end

local treesitter = require("nvim-treesitter.configs")

treesitter.setup({
  ensure_installed = {
    "typescript",
    "markdown",
    "lua",
    "jsonc",
    "css",
    "scss",
    "javascript",
    "html",
    "go",
    "bash",
    "toml",
    "yaml",
    "query",
    "java",
    "vim",
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "plantuml" },
  },
  rainbow = { enable = true, extended_mode = false, max_file_lines = nil },
  matchup = { enable = true },
  refactor = {
    highlight_current_scope = { enable = false },
    highlight_definitions = { enable = false },
  },
  autotag = { enable = true },
  playground = { enable = true },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },
})

-- Highlight the @foo.bar capture group with the "Identifier" highlight group.
-- vim.api.nvim_set_hl(0, "@foo.bar", { link = "Identifier" })
vim.api.nvim_set_hl(0, "@TypescriptTypeIdentifier", { link = "TSType" })
vim.api.nvim_set_hl(0, "@TypescriptAccessibility", { link = "TSKeyword" })
vim.api.nvim_set_hl(0, "@TypescriptImplements", { link = "TSKeyword" })
vim.api.nvim_set_hl(0, "@TypescriptPredefinedType", { link = "TSTypeBuiltin" })
