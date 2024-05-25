return {
  {
    "ibhagwan/fzf-lua",
    lazy = vim.g.started_by_firenvim,
    dependencies = {
      "kyazdani42/nvim-web-devicons", -- optional for icons
      "vijaymarupudi/nvim-fzf",
    },
    config = function()
      require("ld.fzf")
    end,
  },
}
