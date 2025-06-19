local M = {}
-- defaults

function M.set_default(client, bufnr)
  local function buf_set_keymap(...)
    bufnoremap(bufnr, ...)
  end
  local cap = client.server_capabilities

  vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

  if cap.definitionProvider then
    buf_set_keymap("n", "gT", "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Go to type definition")
    buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", "go to  definition")
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
      "<cmd>lua require('ld.telescope.functions').lsp_unique_references({include_current_line = true})<CR>",
      "Show references"
    )
  end

  if cap.documentSymbolProvider then
    buf_set_keymap(
      "n",
      "<leader>lt",
      "<cmd>lua require('ld.fzf').workspace_public_types()<CR>",
      "Workspace type defintions"
    )
    -- search for all kinds of workspace symbols
    -- buf_set_keymap(
    --   "n",
    --   "<leader>lt",
    --   '<cmd>lua require(\'telescope.builtin\').lsp_dynamic_workspace_symbols({symbols={"class","interface"}, file_ignore_patterns={"%.spec.ts","node_modules"}})<CR>',
    --   "Workspace type defintions"
    -- )
    buf_set_keymap(
      "n",
      "<leader>lv",
      "<cmd>lua require('ld.fzf').workspace_public_variables()<CR>",
      "Workspace variable defintions"
    )
    buf_set_keymap(
      "n",
      "<leader>lf",
      "<cmd>lua require('ld.fzf').workspace_public_functions()<CR>",
      "Workspace function defintions"
    )

    -- search for symbols in current buffer via lsp
    -- buf_set_keymap(
    --   "n",
    --   "<leader>bs",
    --   "<cmd>lua require('ld.telescope.functions').lsp_document_symbols()<CR>",
    --   "Search document symbols"
    -- )
    vim.keymap.set("n", "<leader>bs", ":Namu symbols<cr>", {
      desc = "Jump to LSP symbol",
      silent = true,
    })
  end

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
    buf_set_keymap("n", "<leader>lr", "<cmd>lua require('ld.lsp.functions').rename()<CR>", "Rename")
  end

  -- open litee call hierachy ui
  buf_set_keymap("n", "<leader>lh", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", "Call Hierachy")
  buf_set_keymap("v", "<leader>lh", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", "Call Hierachy")
end

function M.set_typescript(client, bufnr)
  local function buf_set_keymap(...)
    bufnoremap(bufnr, ...)
  end

  buf_set_keymap(
    "n",
    "<leader>loi",
    "<cmd>lua require('ld.lsp.functions').format_organize_typescript()<CR>",
    "Format & organize imports"
  )
  -- buf_set_keymap("n", "gr", ":TSLspRenameFile<CR>", 'lsp', 'lsp_', '')
  buf_set_keymap("n", "<leader>loa", "<cmd>VtsExec add_missing_imports<CR>", "Import all")
end
return M
