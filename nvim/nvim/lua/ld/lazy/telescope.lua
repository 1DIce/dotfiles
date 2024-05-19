return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/popup.nvim" },
      { "nvim-lua/plenary.nvim" },
      -- on windows make and gcc need to be installed via scoop
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-live-grep-args.nvim",
      "ThePrimeagen/harpoon",
      "AckslD/nvim-neoclip.lua",
    },
    config = function()
      require("ld.telescope")
    end,
  },
  {
    "AckslD/nvim-neoclip.lua",
    cond = require("ld.utils.functions").is_linux(),
    dependencies = {
      { "tami5/sqlite.lua", module = "sqlite" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("neoclip").setup({ enable_persistent_history = true })
    end,
  },
}
