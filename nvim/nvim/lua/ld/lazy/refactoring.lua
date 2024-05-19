return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
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
