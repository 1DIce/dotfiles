-- neorg treesitter
local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

parser_configs.norg = {
  install_info = {url = "https://github.com/vhyrro/tree-sitter-norg", files = {"src/parser.c"}, branch = "main"}
}

parser_configs.css.used_by = "less"
-- end neorgtreesitter

local treesitter = require 'nvim-treesitter.configs'

treesitter.setup {
  ensure_installed = {"typescript", "angular", "lua", "json", "css", "javascript", "html", "bash", "toml"},
  highlight = {enable = true, additional_vim_regex_highlighting = false},
  rainbow = {enable = true, extended_mode = false, max_file_lines = nil},
  matchup = {enable = true},
  refactor = {highlight_current_scope = {enable = false}, highlight_definitions = {enable = true}},
  autotag = {enable = true}
}
