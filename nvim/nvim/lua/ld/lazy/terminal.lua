return {
  "kassio/neoterm",
  {
    "akinsho/toggleterm.nvim",
    branch = "main",
    config = function()
      require("ld.plugins.toggleterm")
    end,
  },
}
