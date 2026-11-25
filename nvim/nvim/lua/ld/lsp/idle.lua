-- Stop LSP clients nobody has used for a while and restart them on next use,
-- so idle servers give their memory back (kotlin-lsp holds ~1 GB each).
--
-- "Used" means an event in a buffer the client is attached to: entering it,
-- moving the cursor, editing, or focusing Neovim on it. Traffic the server
-- starts itself (diagnostics, refreshes) does not count. A client is never
-- stopped while it reports work-done progress (e.g. indexing).
--
-- A stopped client's buffers are parked. The next event in a parked buffer
-- starts the client again on the same root and reattaches every parked buffer
-- of that root. A client started meanwhile (a new file opened) takes them too.
local M = {}

local uv = vim.uv
local CHECK_INTERVAL_MS = 60 * 1000
local STOP_TIMEOUT_MS = 5000 -- force-kill a server that ignores shutdown/exit
local USE_EVENTS =
  { "BufEnter", "CursorMoved", "CursorMovedI", "TextChanged", "TextChangedI", "FocusGained" }

local timers = {} ---@type table<string, uv.uv_timer_t> watched config name -> idle check
local buf_clients = {} ---@type table<integer, table<integer, true>> bufnr -> watched client ids
local last_used = {} ---@type table<integer, integer> client id -> uv.now() of last use
local busy = {} ---@type table<integer, table<integer|string, true>> client id -> progress tokens
local parked = {} ---@type table<integer, table<string, string>> bufnr -> name -> root ("" = none)

local function label(name, root)
  return root ~= "" and ("%s (%s)"):format(name, vim.fs.basename(root)) or name
end

local function watched_client(id)
  local client = vim.lsp.get_client_by_id(id)
  return client and timers[client.name] and client or nil
end

-- Unpark the buffers of name/root; returns the ones still loaded.
local function take_parked(name, root)
  local bufs = {}
  for buf, entries in pairs(parked) do
    if entries[name] == root then
      entries[name] = nil
      if not next(entries) then
        parked[buf] = nil
      end
      if vim.api.nvim_buf_is_loaded(buf) then
        bufs[#bufs + 1] = buf
      end
    end
  end
  return bufs
end

local function has_stopping_client(name, root)
  for _, client in ipairs(vim.lsp.get_clients({ name = name })) do
    if client:is_stopped() and (client.root_dir or "") == root then
      return true
    end
  end
  return false
end

-- Attach bufs to a name/root client, starting one if none runs.
local function start(name, root, bufs, tries)
  if #bufs == 0 or not vim.lsp.is_enabled(name) then
    return
  end
  -- The old server may still hold resources (kotlin-lsp: its cache slot) until
  -- it exits, so let it finish first. It is force-killed after STOP_TIMEOUT_MS.
  tries = tries or 0
  if tries < 50 and has_stopping_client(name, root) then
    vim.defer_fn(function()
      start(name, root, bufs, tries + 1)
    end, 200)
    return
  end
  local config = vim.lsp.config[name]
  if not config then
    return
  end
  for _, buf in ipairs(bufs) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local c = vim.deepcopy(config)
      c.root_dir = root ~= "" and root or nil
      vim.lsp.start(c, { bufnr = buf })
    end
  end
end

local function park(client, timeout_ms)
  local root = client.root_dir or ""
  for buf in pairs(client.attached_buffers) do
    parked[buf] = parked[buf] or {}
    parked[buf][client.name] = root
  end
  client:stop(STOP_TIMEOUT_MS)
  vim.notify(
    ("%s: stopped after %g min idle, restarts on next use"):format(
      label(client.name, root),
      timeout_ms / 60000
    )
  )
end

local function check(name, timeout_ms)
  local now = uv.now()
  for id in pairs(last_used) do
    if not vim.lsp.get_client_by_id(id) then
      last_used[id], busy[id] = nil, nil
    end
  end
  for _, client in ipairs(vim.lsp.get_clients({ name = name })) do
    local id = client.id
    last_used[id] = last_used[id] or now
    if
      not client:is_stopped()
      and not next(busy[id] or {})
      and now - last_used[id] >= timeout_ms
    then
      park(client, timeout_ms)
    end
  end
end

local group = vim.api.nvim_create_augroup("ld-lsp-idle", { clear = true })

vim.api.nvim_create_autocmd(USE_EVENTS, {
  group = group,
  callback = function(ev)
    local ids = buf_clients[ev.buf]
    if ids then
      local now = uv.now()
      for id in pairs(ids) do
        last_used[id] = now
      end
    end
    for name, root in pairs(parked[ev.buf] or {}) do
      vim.notify(("%s: restarting"):format(label(name, root)))
      start(name, root, take_parked(name, root))
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(ev)
    local client = watched_client(ev.data.client_id)
    if not client then
      return
    end
    buf_clients[ev.buf] = buf_clients[ev.buf] or {}
    buf_clients[ev.buf][client.id] = true
    last_used[client.id] = uv.now()
    local root = client.root_dir or ""
    start(client.name, root, take_parked(client.name, root))
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  group = group,
  callback = function(ev)
    local ids = buf_clients[ev.buf]
    if ids then
      ids[ev.data.client_id] = nil
      if not next(ids) then
        buf_clients[ev.buf] = nil
      end
    end
  end,
})

vim.api.nvim_create_autocmd("LspProgress", {
  group = group,
  pattern = { "begin", "end" },
  callback = function(ev)
    local id = ev.data.client_id
    if not watched_client(id) then
      return
    end
    local token = ev.data.params.token
    if ev.match == "begin" then
      busy[id] = busy[id] or {}
      busy[id][token] = true
    elseif busy[id] then
      busy[id][token] = nil
    end
  end,
})

--- Stop clients of LSP config `name` after `timeout_ms` without use.
---@param name string
---@param timeout_ms integer
function M.watch(name, timeout_ms)
  if timers[name] then
    timers[name]:close()
  end
  local interval = math.min(CHECK_INTERVAL_MS, timeout_ms)
  local timer = assert(uv.new_timer())
  timer:start(
    interval,
    interval,
    vim.schedule_wrap(function()
      check(name, timeout_ms)
    end)
  )
  timers[name] = timer
end

return M
