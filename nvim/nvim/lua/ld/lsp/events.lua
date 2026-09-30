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

-- Forward LSP $/progress as native progress messages: nvim shows them in the
-- message UI / vim.ui.progress_status() and emits the OSC 9;4 terminal
-- progress bar itself (via nvim_ui_send).
local progress_ids = {}
vim.api.nvim_create_autocmd("LspProgress", {
  group = vim.api.nvim_create_augroup("ld-lsp-progress", { clear = true }),
  callback = function(ev)
    local value = ev.data.params.value
    if type(value) ~= "table" or not value.kind then
      return
    end

    local key = ev.data.client_id .. ":" .. tostring(ev.data.params.token)
    if value.kind == "begin" then
      progress_ids[key] = { title = value.title }
    end
    local entry = progress_ids[key]
    if not entry then
      return
    end

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local done = value.kind == "end"
    entry.id = vim.api.nvim_echo({ { value.message or entry.title or "" } }, false, {
      id = entry.id,
      kind = "progress",
      source = client and client.name or "lsp",
      title = entry.title,
      status = done and "success" or "running",
      percent = done and 100 or value.percentage,
    })
    if done then
      progress_ids[key] = nil
    end
  end,
})
