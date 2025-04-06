return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")

      -- REQUIRED
      harpoon:setup()
      -- REQUIRED

      vim.keymap.set("n", "<leader><leader>a", function()
        harpoon:list():add()
      end, { desc = "Add to harpoon list" })
      vim.keymap.set("n", "<leader><leader>f", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Open harpoon ui" })

      vim.keymap.set("n", "<leader><leader>h", function()
        harpoon:list():select(1)
      end, { desc = "Jump to first harpoon file" })
      vim.keymap.set("n", "<leader><leader>j", function()
        harpoon:list():select(2)
      end, { desc = "Jump to second harpoon file" })
      vim.keymap.set("n", "<leader><leader>k", function()
        harpoon:list():select(3)
      end, { desc = "Jump to thrid harpoon file" })
      vim.keymap.set("n", "<leader><leader>l", function()
        harpoon:list():select(4)
      end, { desc = "Jump to forth harpoon file" })

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "<leader><C-p>", function()
        harpoon:list():prev()
      end, { desc = "Jump to next harpoon file" })
      vim.keymap.set("n", "<leader><C-n>", function()
        harpoon:list():next()
      end, { desc = "Jump to prev harpoon file" })
    end,
  },
}
