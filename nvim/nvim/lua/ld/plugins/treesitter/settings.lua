local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
-- end neorgtreesitter
parser_configs.css.used_by = "less"

local treesitter = require 'nvim-treesitter.configs'

treesitter.setup {
    ensure_installed = {
        "typescript", "markdown", "lua", "json", "css", "javascript", "html",
        "bash", "toml", "yaml"
    },
    highlight = {enable = true, additional_vim_regex_highlighting = false},
    rainbow = {enable = true, extended_mode = false, max_file_lines = nil},
    matchup = {enable = true},
    refactor = {
        highlight_current_scope = {enable = false},
        highlight_definitions = {enable = false}
    },
    autotag = {enable = true}
}


