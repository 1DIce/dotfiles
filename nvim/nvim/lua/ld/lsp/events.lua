vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("ld-lsp-attach", { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    require("ld.lsp.remaps").set_default(client, bufnr)

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
  end,
})

-- The following autocommands setup formating on save
local format_on_save_augroup = vim.api.nvim_create_augroup("ld-format_on_save", { clear = true })
-- using special organize imports + formatting with prettier for typescript files
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*.ts,*.tsx",
  group = format_on_save_augroup,
  callback = function(event_data)
    require("ld.lsp.functions").format_organize_typescript(event_data.buf)
  end,
})

-- using ruff to organize imports + formatt for python files
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*.py",
  group = format_on_save_augroup,
  callback = function(event_data)
    local client = vim.lsp.get_clients({ bufnr = bufnr, name = "ruff" })[1]
    if client ~= nil then
      require("ld.lsp.functions").run_code_action_sync("source.fixAll", event_data.buf, client)
    end
    vim.lsp.buf.format({ async = false, bufnr = event_data.buf })
  end,
})

-- using prettierd from null-ls or native lsp client for formatting on save on all those file types
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*.html,*.js,*.yml,*.yaml,*.less,*.json,*.jsonc,*.scss,*.css,*.lua,*.cpp,*.h,*.rs,*.astro,*.go,*.py",
  group = format_on_save_augroup,
  callback = function(event_data)
    vim.lsp.buf.format({ async = false, bufnr = event_data.buf })
  end,
})

vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(ev)
    local value = ev.data.params.value or {}
    if not value.kind then
      return
    end

    local status = value.kind == "end" and 0 or 1
    local percent = value.percentage or 0

    local osc_seq = string.format("\27]9;4;%d;%d\a", status, percent)

    if os.getenv("TMUX") then
      osc_seq = string.format("\27Ptmux;\27%s\27\\", osc_seq)
    end

    io.stdout:write(osc_seq)
    io.stdout:flush()
  end,
})
