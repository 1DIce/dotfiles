return {
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        auto_session_suppress_dirs = { "~/" },
        auto_save_enabled = true,
        auto_restore_enabled = false,
      })
    end,
  },
}
