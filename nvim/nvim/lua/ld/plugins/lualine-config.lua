require'lualine'.setup {
    options = {disabled_filetypes = {'NvimTree'}},
    sections = {
        lualine_a = {{'mode', fmt = function(str) return str:sub(1, 1) end}},
        lualine_b = {'branch', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {},
        lualine_y = {'encoding', 'fileformat'},
        lualine_z = {'filetype'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    }
}
