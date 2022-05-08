local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
-- end neorgtreesitter
parser_configs.css.filetype_to_parsername = "less"

local treesitter = require 'nvim-treesitter.configs'

treesitter.setup {
  ensure_installed = {
    "typescript", "markdown", "lua", "json", "css", "javascript", "html", "go",
    "bash", "toml", "yaml", "query", "java", "vim"
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
    -- custom_captures = {
    --   -- Highlight the @TypescriptThis capture group with the "Identifier" highlight group.
    --   ["TypescriptThis"] = "TypescriptThis"
    -- }
  },
  rainbow = {enable = true, extended_mode = false, max_file_lines = nil},
  matchup = {enable = true},
  refactor = {
    highlight_current_scope = {enable = false},
    highlight_definitions = {enable = false}
  },
  autotag = {enable = true},
  playground = {enable = true},
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = {"BufWrite", "CursorHold"}
  }
}
