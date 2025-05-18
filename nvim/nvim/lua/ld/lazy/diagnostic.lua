return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
      require("tiny-inline-diagnostic").setup({
        preset = "classic",
        transparent_bg = true,
        transparent_cursorline = true,
        options = {
          set_arrow_to_diag_color = true,
          throttle = 200,
          break_line = {
            -- Enable the feature to break messages after a specific length
            enabled = false,
          },
        },
      })
      vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
    end,
  },
}
