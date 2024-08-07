return {
  -- Autocomplete & Linters
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "antosha417/nvim-lsp-file-operations",
    },
  },

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
  "yioneko/nvim-vtsls",
  "onsails/lspkind-nvim",
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      -- disable when a .luarc.json file is found
      enabled = function(root_dir)
        return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
      end,
    },
  },
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
