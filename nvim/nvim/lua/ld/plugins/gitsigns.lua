require("gitsigns").setup({
  on_attach = function(bufnr)
    bufnoremap(
      bufnr,
      "n",
      "<leader>gl",
      '<cmd>Gitsigns setqflist "all"<CR>',
      "Git send all hunks to quickfix list"
    )
    bufnoremap(
      bufnr,
      "n",
      "<leader>gbs",
      '<cmd>lua require"gitsigns".stage_buffer()<CR>',
      "Git stage buffer"
    )
    bufnoremap(
      bufnr,
      "n",
      "<leader>ghs",
      '<cmd>lua require"gitsigns".stage_hunk()<CR>',
      "Git stage hunk"
    )
    bufnoremap(
      bufnr,
      "n",
      "<leader>ghr",
      '<cmd>lua require"gitsigns".reset_hunk()<CR>',
      "Git reset hunk"
    )
    bufnoremap(
      bufnr,
      "n",
      "<leader>gp",
      '<cmd>lua require"gitsigns".blame_line({full = true, ignore_whitespace = true})<CR>',
      "Git show line blame"
    )
    bufnoremap(
      bufnr,
      "n",
      "<leader>ghd",
      '<cmd>lua require"gitsigns".preview_hunk_inline()<CR>',
      "Git show inline diff"
    )
  end,
})
