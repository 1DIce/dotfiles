return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "stevearc/overseer.nvim",
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    },
    config = function()
      vim.keymap.set("n", "<leader>ot", function()
        require("neotest").run.run()
      end, { desc = "Run test at cursor" })

      vim.keymap.set("n", "<leader>oT", function()
        require("neotest").run.run(vim.fn.expand("%"))
      end, { desc = "Run tests in buffer" })

      ---@diagnostic disable-next-line: missing-fields
      require("neotest").setup({
        ---@diagnostic disable-next-line: missing-fields
        output = {
          enabled = false,
        },
        consumers = {
          overseer = require("neotest.consumers.overseer"),
        },
        adapters = {
          require("neotest-python")({
            args = { "-vv" },
            -- Runner to use. Will use pytest if available by default.
            -- Can be a function to return dynamic value.
            runner = "pytest",
            -- Custom python path for the runner.
            -- Can be a string or a list of strings.
            -- Can also be a function to return dynamic value.
            -- If not provided, the path will be inferred by checking for
            -- virtual envs in the local directory and for Pipenev/Poetry configs
            -- python = ".venv/bin/python",
          }),
        },
      })
    end,
  },
}
