return {
  "kyazdani42/nvim-web-devicons", -- icons
  "szw/vim-maximizer",
  "MunifTanjim/nui.nvim", -- ui library

  {
    "stevearc/dressing.nvim",
    config = function()
      require("ld.plugins.dressing")
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons", lazy = true },
    config = function()
      require("ld.plugins.lualine-config")
    end,
  },

  "gennaro-tedesco/nvim-peekup", -- shows register preview
}
