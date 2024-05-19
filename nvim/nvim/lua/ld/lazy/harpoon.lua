return {
  {
    "ThePrimeagen/harpoon",
    config = function()
      require("ld.plugins.harpoon")
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
