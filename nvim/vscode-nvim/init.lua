vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require("lazy").setup({
  "tpope/vim-rsi", -- Readline (bash) keybindings for command mode
  "tpope/vim-repeat", -- extends . repeat, for example for make it work with vim-sneak
  "tpope/vim-surround", -- Change surrounding arks
  "wellle/targets.vim",
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
})

local function nnoremap(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs)
end

local function vnoremap(lhs, rhs, desc)
  vim.keymap.set("v", lhs, rhs)
end

-- Y should yank until end of line similar to D and C
nnoremap("Y", "y$", "Yank to end of line")

nnoremap("<leader>y", '"+y', "yank to clipboard")
vnoremap("<leader>y", '"+y', "yank to clipboard")
nnoremap("<leader>p", '"+p', "paste from clipboard")
vnoremap("<leader>p", '"+p', "paste from clipboard")

-- do not replace register content when pasting in visual mode
vnoremap("p", "pgvy", "Paste does not replace register content")

-- do not replace register content when deleting with 'x'
nnoremap("x", '"_x', "delete character")
vnoremap("x", '"_x', "delete character visual")

-- deletes in visual
vnoremap("X", '"_d', "Deletes on visual")

-- when going to next search, we center screen
nnoremap("n", "nzzzv", "When going to next search, we center screen")
nnoremap("N", "Nzzzv", "When going to previous search, we center screen")

nnoremap("<leader><leader>s", function()
  require("vscode").action("workbench.action.files.save")
end, "Save file")
vnoremap("<leader><leader>s", function()
  require("vscode").action("workbench.action.files.save")
end, "Save file")

nnoremap("<leader>bs", function()
  require("vscode").action("workbench.action.gotoSymbol")
end)
nnoremap("<leader>lt", function()
  require("vscode").action("workbench.action.showAllSymbols")
end)
nnoremap("<leader>lu", function()
  require("vscode").action("editor.action.goToReferences")
end)
