return {
  -- Autocomplete & Linters
  "neovim/nvim-lspconfig",
  {
    "nvimdev/lspsaga.nvim",
    lazy = vim.g.started_by_firenvim,
    config = function()
      local saga = require("lspsaga")
      saga.setup({
        lightbulb = { enable = false },
        beacon = { enable = false },
        symbol_in_winbar = {
          enable = false,
        },
      })
    end,
  },
  "onsails/lspkind-nvim",
  { "ray-x/lsp_signature.nvim", version = "v0.3.1" },
  "jose-elias-alvarez/typescript.nvim",
  "folke/neodev.nvim",
  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  {
    "mfussenegger/nvim-jdtls",
  },
  "b0o/SchemaStore.nvim",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({})
    end,
  },
}
