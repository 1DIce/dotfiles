require("toggleterm").setup({
  -- size can be a number or function which is passed the current terminal
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<A-t>]],
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  terminal_mappings = true -- whether or not the open mapping applies in the opened terminals
})
