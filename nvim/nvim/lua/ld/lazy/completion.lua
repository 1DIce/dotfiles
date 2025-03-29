return {
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("ld.nvim-cmp")
    end,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      { url = "https://codeberg.org/FelipeLema/cmp-async-path.git" },
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-cmdline",
      "rcarriga/cmp-dap",
      {
        "windwp/nvim-autopairs",
        config = function()
          require("ld.nvim-autopairs")
        end,
      },
    },
  },
  {
    "joshzcold/cmp-jenkinsfile",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
  },
}
