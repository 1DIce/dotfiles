return {
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("ld.plugins.treesitter")
    end,
    build = function()
      vim.cmd([[TSUpdate]])
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-refactor",
      "windwp/nvim-ts-autotag",
      "mrjones2014/nvim-ts-rainbow",
      "nvim-treesitter/playground",
      "andymass/vim-matchup",
      {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
          require("ld.plugins.treesitter-context")
        end,
      },
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
          require("ld.plugins.treesitter-textobjects")
        end,
      },
    },
  },
}
