-- neorg treesitter
local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

parser_configs.norg = {
  install_info = {url = "https://github.com/vhyrro/tree-sitter-norg", files = {"src/parser.c"}, branch = "main"}
}
-- end neorgtreesitter
parser_configs.css.used_by = "less"

local treesitter = require 'nvim-treesitter.configs'

treesitter.setup {
  ensure_installed = {"typescript", "lua", "json", "css", "javascript", "html", "bash", "toml", "yaml"},
  highlight = {enable = true, additional_vim_regex_highlighting = true},
  rainbow = {enable = true, extended_mode = false, max_file_lines = nil},
  matchup = {enable = true},
  refactor = {highlight_current_scope = {enable = false}, highlight_definitions = {enable = false}},
  autotag = {enable = true}
}
