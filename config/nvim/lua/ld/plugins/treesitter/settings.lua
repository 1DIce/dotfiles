-- neorg treesitter
local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

parser_configs.norg = {
  install_info = {url = "https://github.com/vhyrro/tree-sitter-norg", files = {"src/parser.c"}, branch = "main"}
}
-- end neorgtreesitter

local treesitter = require 'nvim-treesitter.configs'

treesitter.setup {
  ensure_installed = {
    "typescript", "angular", "html", "tsx", "lua", "json", "rust", "css", "javascript", "c_sharp", "norg", "graphql"
  },
  highlight = {enable = true},
  matchup = {enable = true},
  refactor = {highlight_current_scope = {enable = false}, highlight_definitions = {enable = true}}
}
