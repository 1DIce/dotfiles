return {
  { "jayp0521/mason-null-ls.nvim", dependencies = "williamboman/mason.nvim" },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("ld.lsp.servers.null-ls")
    end,
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  },
}
