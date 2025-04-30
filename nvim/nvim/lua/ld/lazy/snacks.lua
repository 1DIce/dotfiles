return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = false },
      dim = { enabled = false },
      dashboard = {
        preset = {
          keys = {
            {
              icon = "",
              key = "s",
              desc = "Restore session",
              action = ":SessionRestore",
            },
            {
              icon = "",
              key = "f",
              desc = "Find file",
              action = ":lua require('ld.fzf').files()",
            },
            { icon = "", key = "e", desc = "New file", action = ":ene <BAR> startinsert" },
            {
              icon = "",
              key = "r",
              desc = "Recent file",
              action = ":Telescope oldfiles",
            },
            {
              icon = "",
              key = "c",
              desc = "Config",
              action = ":cd $HOME/.config/nvim | lua require('ld.telescope.functions').search_config()",
            },
            { icon = "󰅙", key = "q", desc = "Quit", action = ":qa" },
          },
          header = vim.fn.join({
            [[                                                                       ]],
            [[                                                                     ]],
            [[       ████ ██████           █████      ██                btw  ]],
            [[      ███████████             █████                             ]],
            [[      █████████ ███████████████████ ███   ███████████   ]],
            [[     █████████  ███    █████████████ █████ ██████████████   ]],
            [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
            [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
            [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
            [[                                                                       ]],
          }, "\n"),
        },
      },
      explorer = { enabled = false },
      indent = { enabled = false },
      input = { enabled = true },
      picker = {
        enabled = true,
        layouts = {
          select = {
            layout = {
              -- enable the settings again
              -- when there are not gliches anymore
              -- relative = "cursor",
              -- width = 70,
              min_width = 0,
              -- row = 1,
            },
          },
        },
      },
      notifier = { enabled = true },
      quickfile = { enabled = false },
      scope = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },

      styles = { input = { relative = "cursor" } },
    },
  },
}
