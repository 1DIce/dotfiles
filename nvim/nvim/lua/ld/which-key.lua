local which_key = require("which-key")

which_key.setup({
  win = {
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
  },
  icons = {
    mappings = false, --disable icons
  },
})

which_key.add({
  { "<leader><leader>", group = "super" },
  { "<leader>b", group = "buffer" },
  { "<leader>d", group = "debug" },
  { "<leader>d", group = "debug" },
  { "<leader>e", group = "errors" },
  { "<leader>f", group = "file" },
  { "<leader>g", group = "git" },
  { "<leader>j", group = "jump" },
  { "<leader>ja", group = "jump angular" },
  { "<leader>j", group = "jump" },
  { "<leader>l", group = "lsp" },
  { "<leader>q", group = "qf list" },
  { "<leader>r", group = "rgflow" },
  { "<leader>v", group = "vim" },
  { "<leader>w", group = "window" },
})
