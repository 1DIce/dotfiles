return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    lazy = vim.g.started_by_firenvim,
    config = function()
      ---@diagnostic disable-next-line: missing-parameter
      require("refactoring").setup()

      vnoremap(
        "<leader>re",
        [[ <Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
        "Extract Function"
      )

      vnoremap(
        "<leader>rf",
        [[ <Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
        "Extact Function to file"
      )
    end,
  },
}
