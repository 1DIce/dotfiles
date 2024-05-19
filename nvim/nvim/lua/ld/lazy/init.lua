return {
  "aymericbeaumet/vim-symlink", -- enables nvim to  automatically follow symlinks
  "tpope/vim-rsi", -- Readline (bash) keybindings for command mode
  "tpope/vim-repeat", -- extends . repeat, for example for make it work with vim-sneak
  "tpope/vim-surround", -- Change surrounding arks
  "wellle/targets.vim",

  -- color theme
  "folke/tokyonight.nvim",
  {
    -- visualize hexcode color defintions in code
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "less", "css", "scss" })
    end,
  },
}
