return {
  {
    "Everduin94/nvim-quick-switcher",
    config = function()
      local switcher = require("nvim-quick-switcher")

      nnoremap(
        "<leader>jac",
        [[<cmd>:lua require("nvim-quick-switcher").find('.+component.ts|.+service.ts|.+directive.ts|.+pipe.ts', { regex = true, maxdepth = 1 })<CR>]],
        "Switch to ts class file"
      )
      nnoremap(
        "<leader>jat",
        "<cmd>:lua require('nvim-quick-switcher').find('.spec.ts', {  maxdepth = 1, prefix = 'full' })<CR>",
        "Switch to ts test file"
      )
      nnoremap(
        "<leader>jah",
        "<cmd>:lua require('nvim-quick-switcher').find('.+html', { regex = true, maxdepth = 1 })<CR>",
        "Switch to html file"
      )
      nnoremap(
        "<leader>jas",
        "<cmd>:lua require('nvim-quick-switcher').find('.+css|.+scss|.+sass|.+less', { regex = true, maxdepth = 1 })<CR>",
        "Switch to css file"
      )
    end,
  },
}
