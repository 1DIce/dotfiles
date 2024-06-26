return {
  {
    -- neovim welcome screen
    "goolord/alpha-nvim",
    lazy = vim.g.started_by_firenvim,
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Set header
      dashboard.section.header.val = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                                     ",
      }

      -- Set menu
      dashboard.section.buttons.val = {
        dashboard.button("s", "  > Restore session", ":SessionRestore <CR><CR>"),
        dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", "  > Find file", ":lua require('ld.fzf').files()<CR>"),
        dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
        dashboard.button(
          "c",
          "  > Nvim config",
          ":cd $HOME/.config/nvim | lua require('ld.telescope.functions').search_config() <CR>"
        ),
        dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
      }

      -- Send config to alpha
      alpha.setup(dashboard.opts)
    end,
  },
}
