return {
  {

    "stevearc/overseer.nvim",
    config = function()
      vim.keymap.set("n", "<leader>oo", function()
        vim.cmd("OverseerToggle")
      end, { desc = "Overseer toggle Ui" })

      require("overseer").setup({
        task_list = {
          max_height = { 100, 0.5 },
          height = 100,
        },
      })
    end,
  },
}
