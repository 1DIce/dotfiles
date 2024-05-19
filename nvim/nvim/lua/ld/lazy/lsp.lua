return {
  -- Autocomplete & Linters
  "neovim/nvim-lspconfig",
  "tjdevries/lsp_extensions.nvim",
  "nvimdev/lspsaga.nvim",
  "onsails/lspkind-nvim",
  { "ray-x/lsp_signature.nvim", version = "v0.2.0" },
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
