local M = {}
-- defaults

function M.set_default(client, bufnr)
  local function buf_set_keymap(...) bufnoremap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  local cap = client.server_capabilities

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  if cap.definitionProvider then
    buf_set_keymap("n", "gD",
        "<cmd>lua require('lspsaga.provider').preview_definition()<CR>",
        "Preview definition")
    buf_set_keymap("n", "gT", "<cmd>lua vim.lsp.buf.type_definition()<CR>",
        "Go to type definition")
    buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>",
        "Preview definition")
  end

  if cap.implementationProvider then
    buf_set_keymap("n", "<leader>li",
        "<cmd>lua vim.lsp.buf.implementation()<CR>", "Go to implementation")
  end
  if cap.referencesProvider then
    buf_set_keymap("n", "<leader>lu",
        "<cmd>lua require('ld.plugins.telescope.functions').lsp_unique_references({})<CR>",
        "Show references")
  end

  -- buf_set_keymap('n','<leader>th', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap("n", "K",
      "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>",
      "Hover documentation")

  if cap.documentSymbolProvider then
    -- search for all kinds of workspace symbols
    buf_set_keymap("n", "<leader>lt",
        "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols({symbols={\"class\",\"interface\"}, file_ignore_patterns={\"%.spec.ts\",\"node_modules\"}})<CR>",
        "Workspace type defintions")
    buf_set_keymap("n", "<leader>lc",
        "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols({symbols={\"constant\"}, file_ignore_patterns={\"%.spec.ts\",\"^e2e/\",\"node_modules\"}})<CR>",
        "Workspace constant defintions")
    buf_set_keymap("n", "<leader>lf",
        "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols({symbols={\"function\"}, file_ignore_patterns={\"%.spec.ts\",\"^e2e/\",\"node_modules\"}})<CR>",
        "Workspace function defintions")
    buf_set_keymap("n", "<leader>lp",
        "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols({symbols={\"property\"}, file_ignore_patterns={\"%.spec.ts\",\"^e2e/\",\"node_modules\"}})<CR>",
        "Workspace property defintions")

    -- search for symbols in current buffer
    buf_set_keymap("n", "<leader>bs",
        "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>",
        "Search document symbols")
  end

  buf_set_keymap("n", "<leader>lv",
      "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>",
      "Show signature")

  -- if cap.workspaceSymbolProvider then
  --   map('n','<leader>gW','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
  -- end

  if cap.codeActionProvider then
    buf_set_keymap("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>",
        "code action")
    buf_set_keymap("v", "<leader>la",
        "<cmd>lua vim.lsp.buf.range_code_action()<CR>", "range code action")
  end

  -- buf_set_keymap('n','<leader>fe', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
  -- buf_set_keymap('n','<leader>fe', '<cmd>:LspDiagnostics 0<CR>', opts)
  -- buf_set_keymap('n', '<leader>fe', '<cmd>lua require(\'ld.lsp.functions\').show_diagnostics()<CR>', 'lsp',
  --                'lsp_show_diagnostics', 'Show diagnostics')
  buf_set_keymap("n", "<leader>lew",
      "<cmd>lua require('telescope.builtin').diagnostics()<CR>",
      "Show workspace diagnostics")
  buf_set_keymap("n", "<leader>leb",
      "<cmd>lua require('telescope.builtin').lsp_document_diagnostics()<CR>",
      "Show buffer diagnostics")
  -- buf_set_keymap('n','<leader>fE', '<cmd>lua vim.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap("n", "<leader>lel",
      "<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>",
      "Show line diagnostics")
  buf_set_keymap("n", "<leader>lep", "<cmd>lua vim.diagnostic.goto_prev()<CR>",
      "Previous diagnostic")
  buf_set_keymap("n", "<leader>len", "<cmd>lua vim.diagnostic.goto_next()<CR>",
      "next diagnostic")
  --[[ buf_set_keymap('n', '[e', "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>", 'lsp', 'lsp_previous_diagnostic', 'Previous diagnostic')
  buf_set_keymap('n', ']e', "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>", 'lsp', 'lsp_next_diagnostic', 'Next diagnostic'); ]]

  if cap.documentFormattingProvider then
    buf_set_keymap("n", "<leader>lof", "<cmd>lua vim.lsp.buf.formatting()<CR>",
        "Format")
  elseif cap.documentRangeFormattingProvider then
    buf_set_keymap("n", "<leader>lof", "<cmd>lua vim.lsp.buf.formatting()<CR>",
        "Format")
  end

  if cap.renameProvider then
    -- buf_set_keymap('n','<leader>rr','<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap("n", "<leader>lr",
        "<cmd>lua require('lspsaga.rename').rename()<CR>", "Rename")
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
  local function buf_set_keymap(...) bufnoremap(bufnr, ...) end
  local ts_utils = require("nvim-lsp-ts-utils")

  -- defaults
  ts_utils.setup {update_imports_on_move = true}

  -- required to fix code action ranges and filter diagnostics
  ts_utils.setup_client(client)

  buf_set_keymap("n", "<leader>loi", ":TSLspOrganize<CR>", "Organize imports")
  -- buf_set_keymap("n", "gr", ":TSLspRenameFile<CR>", 'lsp', 'lsp_', '')
  buf_set_keymap("n", "<leader>loa", ":TSLspImportAll<CR>", "Import all")
end
return M
