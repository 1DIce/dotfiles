return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
    config = function()
      require("ld.dap")
    end,
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
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = { "codelldb" },
        handlers = {}, -- sets up dap in the predefined manner
      })
    end,
  },
}
