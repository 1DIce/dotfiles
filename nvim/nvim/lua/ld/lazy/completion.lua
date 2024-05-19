return {
  "mattn/emmet-vim",
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("ld.plugins.nvim-cmp")
    end,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-cmdline",
      "joshzcold/cmp-jenkinsfile",
      {
        "windwp/nvim-autopairs",
        config = function()
          require("ld.plugins.nvim-autopairs")
        end,
      },
    },
  },
}