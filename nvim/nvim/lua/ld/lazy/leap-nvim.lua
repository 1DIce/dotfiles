local function setup_clever_f_motions()
  do
    -- Return an argument table for `leap()`, tailored for f/t-motions.
    local function as_ft(key_specific_args)
      local common_args = {
        inputlen = 1,
        inclusive = true,
        -- To limit search scope to the current line:
        -- pattern = function (pat) return '\\%.l'..pat end,
        opts = {
          labels = "", -- force autojump

          -- Match the modes here for which you don't want to use labels
          --   (`:h mode()`, `:h lua-pattern`).
          safe_labels = vim.fn.mode(1):match("[no]") and "" or nil,
        },
      }
      return vim.tbl_deep_extend("keep", common_args, key_specific_args)
    end

    --  This helper function makes it easier to set "clever-f"-like
    --  functionality (https://github.com/rhysd/clever-f.vim), returning
    --  an `opts` table derived from the defaults, where the given keys
    --  are added to `keys.next_target` and `keys.prev_target`
    local clever = require("leap.user").with_traversal_keys
    local clever_f = clever("f", "F")
    local clever_t = clever("t", "T")

    for key, key_specific_args in pairs({
      f = { opts = clever_f },
      F = { backward = true, opts = clever_f },
      t = { offset = -1, opts = clever_t },
      T = { backward = true, offset = 1, opts = clever_t },
    }) do
      vim.keymap.set({ "n", "x", "o" }, key, function()
        require("leap").leap(as_ft(key_specific_args))
      end)
    end
  end
end

return {
  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
    config = function()
      local leap = require("leap")
      leap.init_highlight(true)
      leap.opts.safe_labels = {}
      setup_clever_f_motions()

      vim.keymap.set("n", "s", "<Plug>(leap)")
      -- leap into other window
      vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
    end,
  },
}
