return {
  {

    {
      "antosha417/nvim-lsp-file-operations",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-tree.lua",
      },
      lazy = vim.g.started_by_firenvim,
      config = function()
        require("ld.nvim-tree")
        require("lsp-file-operations").setup()
      end,
    },
  },
}
