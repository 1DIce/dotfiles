local tree_api_fs = require("nvim-tree.api").fs

local function on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return {
      desc = "nvim-tree: " .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true,
    }
  end

  api.config.mappings.default_on_attach(bufnr)

  -- CUSTOM mappings
  vim.keymap.set(
    "n",
    "C",
    ":lua require('ld.nvim-tree.functions').executeShellCommandOnTreeNode()<CR>",
    opts("Execute shell command")
  )
end

require("nvim-tree").setup({
  on_attach = on_attach,
  update_focused_file = { enable = true, update_cwd = false, ignore_list = {} },
  view = {
    -- width of the window, can be either a number (columns) or a string in `%`
    width = 50,
    -- side of the tree, can be one of 'left' | 'right' | 'top' | 'bottom'
    side = "left",
    -- if true the tree will resize itself after opening a file
  },
  renderer = {
    group_empty = true,
  },
  git = { enable = false },
  actions = { open_file = { quit_on_open = true } },
})
