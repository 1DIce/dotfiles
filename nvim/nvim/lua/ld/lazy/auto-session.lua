return {
  {
    "rmagatti/auto-session",
    lazy = vim.g.started_by_firenvim,
    config = function()
      require("auto-session").setup({
        auto_session_suppress_dirs = { "~/" },
        auto_save_enabled = true,
        auto_restore_enabled = false,
      })
    end,
  },
}
