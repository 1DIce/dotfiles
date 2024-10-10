return {

  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod" },
    },
    init = function()
      -- DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_execute_on_save = 0
    end,
  },
  { "kristijanhusak/vim-dadbod-completion" },
}
