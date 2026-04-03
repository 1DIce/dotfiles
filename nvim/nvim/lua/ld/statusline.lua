local M = {}

-- Mode display mapping
local mode_map = {
  n = "NORMAL",
  i = "INSERT",
  v = "VISUAL",
  V = "V-LINE",
  ["\22"] = "V-BLOCK",
  c = "COMMAND",
  R = "REPLACE",
  t = "TERMINAL",
  s = "SELECT",
  S = "S-LINE",
  ["\19"] = "S-BLOCK",
}

-- Mode highlight group mapping
local mode_hl = {
  n = "StlModeNormal",
  i = "StlModeInsert",
  v = "StlModeVisual",
  V = "StlModeVisual",
  ["\22"] = "StlModeVisual",
  c = "StlModeCommand",
  R = "StlModeReplace",
  t = "StlModeTerminal",
  s = "StlModeVisual",
  S = "StlModeVisual",
  ["\19"] = "StlModeVisual",
}

function M.mode()
  local m = vim.fn.mode()
  local label = mode_map[m] or m
  local hl = mode_hl[m] or "StatusLine"
  return "%#" .. hl .. "# " .. label .. " %#StatusLine#"
end

-- Define mode highlight groups from tokyonight palette
local function setup_highlights()
  local ok, colors = pcall(function()
    return require("tokyonight.colors").setup()
  end)
  if not ok then
    return
  end

  local groups = {
    StlModeNormal = { bg = colors.blue, fg = colors.black, bold = true },
    StlModeInsert = { bg = colors.green, fg = colors.black, bold = true },
    StlModeVisual = { bg = colors.magenta, fg = colors.black, bold = true },
    StlModeCommand = { bg = colors.yellow, fg = colors.black, bold = true },
    StlModeReplace = { bg = colors.red, fg = colors.black, bold = true },
    StlModeTerminal = { bg = colors.teal, fg = colors.black, bold = true },
  }

  for name, opts in pairs(groups) do
    vim.api.nvim_set_hl(0, name, opts)
  end
end

-- Global statusline
vim.o.laststatus = 3

vim.o.statusline = table.concat({
  "%{%v:lua.require('ld.statusline').mode()%}",
  " %{FugitiveHead()} ",
  " %{%v:lua.vim.diagnostic.status()%} ",
  "%=",
  " %P %l:%c ",
  " %{&fileencoding} %{&fileformat} ",
  " %y ",
})

-- Winbar: show filename in all windows
vim.o.winbar = " %f"

-- Disable winbar for specific filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "nvim-dap-view",
    "dap-view-term",
    "dap-view",
    "NvimTree",
    "fugitive",
    "gitcommit",
    "alpha",
    "neoterm",
    "snacks_dashboard",
    "toggleterm",
  },
  callback = function()
    vim.wo.winbar = nil
  end,
})

-- Set up highlights now and on colorscheme change
setup_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = setup_highlights,
})

return M
