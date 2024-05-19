return {
  "kyazdani42/nvim-web-devicons", -- icons
  "szw/vim-maximizer",
  "MunifTanjim/nui.nvim", -- ui library

  {
    "stevearc/dressing.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("dressing").setup({
        select = { telescope = require("telescope.themes").get_cursor() },
      })
    end,
  },

  "gennaro-tedesco/nvim-peekup", -- shows register preview
}
