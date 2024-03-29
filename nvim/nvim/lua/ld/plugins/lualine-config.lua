require("lualine").setup({
  options = {
    disabled_filetypes = { winbar = { "NvimTree", "fugitive", "gitcommit", "alpha", "neoterm" } },
    globalstatus = true,
  },
  sections = {
    lualine_a = {
      { "mode" },
    },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = {},
    lualine_x = { "progress", "location" },
    lualine_y = { "encoding", "fileformat" },
    lualine_z = { "filetype" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },

  winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
})
