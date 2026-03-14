return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/popup.nvim" },
      { "nvim-lua/plenary.nvim" },
      -- on windows make and gcc need to be installed via scoop
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "ThePrimeagen/harpoon",
    },
    config = function()
      require("ld.telescope")
    end,
  },
}
