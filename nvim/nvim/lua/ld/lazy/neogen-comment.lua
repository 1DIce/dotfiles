return {
  {
    -- code comment string generation
    "danymat/neogen",
    config = function()
      require("neogen").setup({
        enabled = true,
        languages = {
          lua = {
            template = {
              annotation_convention = "emmylua", -- for a full list of annotation_conventions, see supported-languages below,
            },
          },
          typescript = {
            template = {
              annotation_convention = "tsdoc",
            },
          },
        },
      })

      nnoremap("<Leader>ld", ":lua require('neogen').generate()<CR>", "Generate doc string")
    end,
  },
}
