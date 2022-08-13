local telescope = require("telescope")
local action_layout = require("telescope.actions.layout")
local functions = require("ld.utils.functions")

telescope.setup({
  defaults = {
    layout_config = { prompt_position = "top" },
    path_display = { "smart" },
    mappings = {
      i = {
        -- mappings are used while telescope prompt is open
        ["<C-h>"] = "which_key", -- actions.which_key shows the mappings for your picker,
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
        ["<F4>"] = action_layout.toggle_preview,
      },
      n = { ["<F4>"] = action_layout.toggle_preview },
    },
    sorting_strategy = "ascending",
    timeoutlen = 2000,
    prompt_prefix = ">",
    file_ignore_patterns = {
      ".backup",
      ".swap",
      ".langservers",
      ".session",
      ".undo",
      "*.git",
      "node_modules",
      "vendor",
      ".cache",
      ".vscode-server",
      ".Desktop",
      ".Documents",
      "classes",
      "package-lock.json",
    },
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case" the default case_mode is "smart_case"
      --  ,tiebreak = {}
    },
  },
  pickers = {
    buffers = { sort_mru = true },
    lsp_dynamic_workspace_symbols = { debounce = 300 },
  },
})

functions.link_highlight("TelescopeBorder", "GruvboxBg2", true)
functions.link_highlight("TelescopePromptBorder", "GruvboxBg2", true)
functions.link_highlight("TelescopeResultsBorder", "GruvboxBg2", true)
functions.link_highlight("TelescopePreviewBorder", "GruvboxBg2", true)

if functions.is_linux() then
  telescope.load_extension("neoclip")
end
telescope.load_extension("fzf")
telescope.load_extension("harpoon")
telescope.load_extension("live_grep_args")
