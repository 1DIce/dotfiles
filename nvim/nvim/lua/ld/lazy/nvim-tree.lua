return {
  {
    "kyazdani42/nvim-tree.lua",
    lazy = vim.g.started_by_firenvim,
    config = function()
      require("ld.nvim-tree")
    end,
  },
}
