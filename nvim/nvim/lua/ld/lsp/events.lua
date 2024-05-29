vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("ld-lsp-attach", { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    if client and client.server_capabilities.documentHighlightProvider then
      local highlight_augroup = vim.api.nvim_create_augroup("ld-lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("ld-lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "ld-lsp-highlight", buffer = event2.buf })
        end,
      })
    end

    if not vim.tbl_contains({ "null-ls" }, client.name) then -- blacklist lsp
      -- add signature autocompletion while typing
      require("lsp_signature").on_attach({
        floating_window = false,
        timer_interval = 500,
      }, bufnr)
    end
  end,
})

-- The following autocommands setup formating on save
local format_on_save_augroup = vim.api.nvim_create_augroup("ld-format_on_save", { clear = true })
-- using special organize imports + formatting with prettier for typescript files
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*.ts",
  group = format_on_save_augroup,
  callback = function()
    require("ld.lsp.functions").format_organize_typescript()
  end,
})

-- using prettierd from null-ls or native lsp client for formatting on save on all those file types
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*.html,*.js,*.yml,*.yaml,*.less,*.json,*.jsonc,*.scss,*.css,*.lua,*.cpp,*.h,*.rs",
  group = format_on_save_augroup,
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
