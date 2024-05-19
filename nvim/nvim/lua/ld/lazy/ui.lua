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

  "gennaro-tedesco/nvim-peekup", -- shows register preview
}
