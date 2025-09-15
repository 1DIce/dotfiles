return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {
      model = "gpt-4.1", -- AI model to use
      temperature = 0.1, -- Lower = focused, higher = creative
      window = {
        layout = "vertical", -- 'vertical', 'horizontal', 'float'
        width = 0.5, -- 50% of screen width
      },
      auto_insert_mode = true, -- Enter insert mode when opening
    },
  },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   config = function()
  --     require("copilot").setup({
  --       panel = {
  --         enabled = false,
  --       },
  --       suggestion = {
  --         enabled = false,
  --       },
  --     })
  --   end,
  -- },
  -- {
  --   "copilotlsp-nvim/copilot-lsp",
  --   init = function()
  --     vim.g.copilot_nes_debounce = 200
  --     vim.lsp.enable("copilot_ls")
  --
  --     vim.keymap.set("n", "<tab>", function()
  --       -- Try to jump to the start of the suggestion edit.
  --       -- If already at the start, then apply the pending suggestion and jump to the end of the edit.
  --       local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
  --         or (
  --           require("copilot-lsp.nes").apply_pending_nes()
  --           and require("copilot-lsp.nes").walk_cursor_end_edit()
  --         )
  --     end)
  --
  --     -- Clear copilot suggestion with Esc if visible, otherwise preserve default Esc behavior
  --     vim.keymap.set("n", "<esc>", function()
  --       if not require("copilot-lsp.nes").clear() then
  --         -- fallback to other functionality
  --       end
  --     end, { desc = "Clear Copilot suggestion or fallback" })
  --   end,
  -- },

  -- {
  --   "olimorris/codecompanion.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "zbirenbaum/copilot.lua",
  --   },
  --   config = function()
  --     require("codecompanion").setup({})
  --   end,
  -- },
}
