return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
    lazy = vim.g.started_by_firenvim,
    config = function()
      require("ld.dap")
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    lazy = vim.g.started_by_firenvim,
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = { "codelldb" },
        handlers = {}, -- sets up dap in the predefined manner
      })
    end,
  },
}
