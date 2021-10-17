local telescope = require 'telescope'
local functions = require 'lt.utils.functions'

telescope.setup {
    defaults = {
        layout_config = {
          prompt_position = 'top',
        },

   mappings = {
      i = {
        -- mappings are used while telescope prompt is open
        ["<C-h>"] = "which_key", -- actions.which_key shows the mappings for your picker,
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous"
      }
    },
        sorting_strategy = "ascending",
        timeoutlen = 2000,
        prompt_prefix = '>',
        file_ignore_patterns = {
            '.backup', '.swap', '.langservers', '.session', '.undo', '*.git',
            'node_modules', 'vendor', '.cache', '.vscode-server', '.Desktop',
            '.Documents', 'classes'
        },
        borderchars = {'─', '│', '─', '│', '╭', '╮', '╯', '╰'},
        color_devicons = true,
        set_env = {['COLORTERM'] = 'truecolor'}, -- default = nil,
    },
    pickers = {
    } 
  }

functions.link_highlight('TelescopeBorder', 'GruvboxBg2', true)
functions.link_highlight('TelescopePromptBorder', 'GruvboxBg2', true)
functions.link_highlight('TelescopeResultsBorder', 'GruvboxBg2', true)
functions.link_highlight('TelescopePreviewBorder', 'GruvboxBg2', true)

if functions.is_linux() then telescope.load_extension('fzf') end
telescope.load_extension('mapper')
telescope.load_extension('projects')
