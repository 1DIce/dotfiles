return {
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      "kyazdani42/nvim-web-devicons", -- optional for icons
      "vijaymarupudi/nvim-fzf",
    },
    config = function()
      require("ld.fzf")
    end,
  },
}
