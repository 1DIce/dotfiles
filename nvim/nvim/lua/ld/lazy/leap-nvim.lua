return {
  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
    dependencies = {
      "ggandor/flit.nvim", -- for better f and t motions
    },
    config = function()
      local leap = require("leap")
      leap.init_highlight(true)
      leap.opts.safe_labels = {}
      require("flit").setup({})
      vim.keymap.set("n", "s", "<Plug>(leap)")
      -- leap into other window
      vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
    end,
  },
}
