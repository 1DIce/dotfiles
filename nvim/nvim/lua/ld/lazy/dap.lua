return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("ld.dap")
    end,
  },
  {
    "igorlfs/nvim-dap-view",
    dependencies = { { "mfussenegger/nvim-dap" } },
    ---@module 'dap-view'
    ---@type dapview.Config
    opts = {
      winbar = {
        -- Adding a "console" section to merge the terminal with the other views
        sections = {
          "watches",
          "scopes",
          "exceptions",
          "breakpoints",
          "threads",
          "repl",
          "console",
        },
        default_section = "scopes",
      },
    },
  },
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { { "mfussenegger/nvim-dap" } },
    config = function()
      -- debugpy needs to be installed via uv
      -- uv tool install debugpy
      require("dap-python").setup("uv")
      vim.api.nvim_create_user_command("PythonDebugTest", function()
        require("dap-python").test_method()
      end, {})
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
  },
}
