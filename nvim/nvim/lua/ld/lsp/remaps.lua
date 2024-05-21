local M = {}
-- defaults

function M.set_default(client, bufnr)
  local function buf_set_keymap(...)
    bufnoremap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end
  local cap = client.server_capabilities

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  if cap.definitionProvider then
    buf_set_keymap("n", "gD", "<cmd>Lspsaga peek_definition<CR>", "Preview definition")
    buf_set_keymap("n", "gT", "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Go to type definition")
    buf_set_keymap(
      "n",
      "gd",
      "<cmd>lua require('ld.lsp.functions').go_to_definition()<CR>",
      "go to  definition"
    )
  end

  if cap.implementationProvider then
    buf_set_keymap(
      "n",
      "<leader>li",
      "<cmd>lua vim.lsp.buf.implementation()<CR>",
      "Go to implementation"
    )
  end
  if cap.referencesProvider then
    buf_set_keymap(
      "n",
      "<leader>lu",
      "<cmd>lua require('ld.telescope.functions').lsp_unique_references({})<CR>",
      "Show references"
    )
  end

  -- buf_set_keymap('n','<leader>th', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", "Hover documentation")

  if cap.documentSymbolProvider then
    -- search for all kinds of workspace symbols
    buf_set_keymap(
      "n",
      "<leader>lt",
      '<cmd>lua require(\'telescope.builtin\').lsp_dynamic_workspace_symbols({symbols={"class","interface"}, file_ignore_patterns={"%.spec.ts","node_modules"}})<CR>',
      "Workspace type defintions"
    )
    buf_set_keymap(
      "n",
      "<leader>lc",
      '<cmd>lua require(\'telescope.builtin\').lsp_dynamic_workspace_symbols({symbols={"constant"}, file_ignore_patterns={"%.spec.ts","^e2e/","node_modules"}})<CR>',
      "Workspace constant defintions"
    )
    buf_set_keymap(
      "n",
      "<leader>lf",
      '<cmd>lua require(\'telescope.builtin\').lsp_dynamic_workspace_symbols({symbols={"function"}, file_ignore_patterns={"%.spec.ts","^e2e/","node_modules"}})<CR>',
      "Workspace function defintions"
    )
    buf_set_keymap(
      "n",
      "<leader>lp",
      '<cmd>lua require(\'telescope.builtin\').lsp_dynamic_workspace_symbols({symbols={"property"}, file_ignore_patterns={"%.spec.ts","^e2e/","node_modules"}})<CR>',
      "Workspace property defintions"
    )

    -- search for symbols in current buffer via lsp
    buf_set_keymap(
      "n",
      "<leader>bs",
      "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>",
      "Search document symbols"
    )
  else
    -- search for symbols in current buffer via treesitter -> only needed if lsp is not available
    buf_set_keymap(
      "n",
      "<leader>bs",
      "<cmd>lua require('telescope.builtin').treesitter()<CR>",
      "Search document symbols"
    )
  end

  buf_set_keymap("i", "<c-H>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Show signature")

  -- if cap.workspaceSymbolProvider then
  --   map('n','<leader>gW','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
  -- end

  if cap.codeActionProvider then
    buf_set_keymap("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", "code action")
    buf_set_keymap("v", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", "range code action")
  end

  if cap.documentFormattingProvider then
    buf_set_keymap("n", "<leader>lof", "<cmd>lua vim.lsp.buf.format({async = true})<CR>", "Format")
  elseif cap.documentRangeFormattingProvider then
    buf_set_keymap("n", "<leader>lof", "<cmd>lua vim.lsp.buf.format({async = true})<CR>", "Format")
  end

  if cap.renameProvider then
    -- buf_set_keymap('n','<leader>rr','<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename")
    -- buf_set_keymap('n', '<leader>lr', '<cmd>lua require(\'renamer\').rename()<cr>', 'lsp', 'lsp_rename', 'Rename')
  end

  -- buf_set_keymap('n','<leader>fll', ":lua vim.cmd('e'..vim.lsp.get_log_path())<CR>", opts)
  buf_set_keymap("n", "<leader>lli", ":LspInfo()<CR>", "[DEBUG] LSP Info")

  -- map('n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>')
  -- map('n','gi','<cmd>lua vim.lsp.buf.implementation()<CR>')
  -- map('n','<leader>ah','<cmd>lua vim.lsp.buf.hover()<CR>')
  -- map('n','<leader>ai','<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
  -- map('n','<leader>ao','<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')
end

function M.set_typescript(client, bufnr)
  local function buf_set_keymap(...)
    bufnoremap(bufnr, ...)
  end

  buf_set_keymap(
    "n",
    "<leader>loi",
    "<cmd>lua require('ld.lsp.functions').typescript_organize_imports()<CR>",
    "Organize imports"
  )
  -- buf_set_keymap("n", "gr", ":TSLspRenameFile<CR>", 'lsp', 'lsp_', '')
  buf_set_keymap("n", "<leader>loa", ":TypescriptAddMissingImports<CR>", "Import all")
end
return M
