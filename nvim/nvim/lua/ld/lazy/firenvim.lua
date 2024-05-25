vim.g.firenvim_config = {
  globalSettings = {
    ["<C-w>"] = "noop",
    ["<C-n>"] = "default",
  },
  localSettings = {
    [".*"] = { takeover = "never" },
  },
}

return {
  {
    "glacambre/firenvim",
    -- Lazy load firenvim
    -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    lazy = not vim.g.started_by_firenvim,
    tag = "0.2.16",
    build = function()
      vim.fn["firenvim#install"](0)
    end,
    config = function()
      if vim.g.started_by_firenvim then
        vim.cmd([[ set guifont=UbuntuMono\ Nerd\ Font ]])
      end
    end,
  },
}
