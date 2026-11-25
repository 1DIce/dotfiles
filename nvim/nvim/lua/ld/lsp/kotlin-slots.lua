-- Per-workspace cache slots for kotlin-lsp.
--
-- kotlin-lsp locks its --system-path and its index database, so two servers on
-- one workspace (e.g. two Neovims) need separate dirs. Each server claims a
-- free slot and runs with --system-path=<slot> and indexDir=<slot>/index.
-- Slots are reused, so after the first index a server starts warm.
--
-- A lock is a symlink slot-N.lock whose target is the pid of the Neovim that
-- holds it. The lock is released when the server exits. A lock whose Neovim is
-- gone is stale and gets reclaimed.
local M = {}

local uv = vim.uv
local BASE = vim.fs.joinpath(vim.fn.stdpath("cache"), "kotlin-lsp")
local MAX_SLOTS = 4
local PID = tostring(uv.os_getpid())

local function workspace_dir(root)
  return vim.fs.joinpath(BASE, vim.fs.basename(root) .. "-" .. vim.fn.sha256(root):sub(1, 8))
end

-- True if the Neovim that holds lock still runs.
local function is_live(lock)
  local pid = tonumber(uv.fs_readlink(lock) or "")
  if not pid then
    return false
  end
  local ok, _, code = uv.kill(pid, 0)
  return ok == 0 or code == "EPERM"
end

local function try_claim(lock)
  return uv.fs_symlink(PID, lock) == true
end

--- Claim a free slot for root. Returns the slot dir, or nil if all are in use.
---@param root string
---@return string?
function M.claim(root)
  local ws = workspace_dir(root)
  vim.fn.mkdir(ws, "p")
  vim.fn.writefile({ root }, vim.fs.joinpath(ws, "root"))
  for n = 1, MAX_SLOTS do
    local slot = vim.fs.joinpath(ws, "slot-" .. n)
    local lock = slot .. ".lock"
    if try_claim(lock) then
      return slot
    end
    -- Stale: reclaim once; if another Neovim wins the symlink, move on.
    if not is_live(lock) then
      os.remove(lock)
      if try_claim(lock) then
        return slot
      end
    end
  end
end

local held = {} ---@type table<string, true> slots this Neovim holds

--- Release a slot this Neovim holds.
---@param slot string
function M.release(slot)
  held[slot] = nil
  local lock = slot .. ".lock"
  if uv.fs_readlink(lock) == PID then
    os.remove(lock)
  end
end

-- On quit Neovim can exit before a server's on_exit runs. VimLeave comes after
-- the LSP clients are stopped in VimLeavePre.
vim.api.nvim_create_autocmd("VimLeave", {
  group = vim.api.nvim_create_augroup("ld-kotlin-slots", { clear = true }),
  callback = function()
    for slot in pairs(held) do
      M.release(slot)
    end
  end,
})

--- Start kotlin-lsp on a claimed slot. Use as the `cmd` of an LSP config.
---@param dispatchers vim.lsp.rpc.Dispatchers
---@param config vim.lsp.ClientConfig
function M.start(dispatchers, config)
  local root = config.root_dir or assert(uv.cwd())
  local slot = M.claim(root)
  if not slot then
    error(("kotlin-lsp: all %d cache slots for %s are in use"):format(MAX_SLOTS, root), 0)
  end
  held[slot] = true
  config.init_options =
    vim.tbl_extend("force", config.init_options or {}, { indexDir = slot .. "/index" })
  local on_exit = dispatchers.on_exit
  dispatchers = vim.tbl_extend("force", dispatchers, {
    on_exit = function(...)
      M.release(slot)
      return on_exit(...)
    end,
  })
  local ok, rpc =
    pcall(vim.lsp.rpc.start, { "kotlin-lsp", "--stdio", "--system-path=" .. slot }, dispatchers)
  if not ok then
    M.release(slot)
    error(rpc, 0)
  end
  return rpc
end

-- Calls fn(ws, root, slots) per workspace; slots maps slot dir -> lock state.
local function each_workspace(fn)
  if vim.fn.isdirectory(BASE) == 0 then
    return
  end
  for name, type in vim.fs.dir(BASE) do
    if type == "directory" then
      local ws = vim.fs.joinpath(BASE, name)
      local root_file = vim.fs.joinpath(ws, "root")
      local root = vim.fn.filereadable(root_file) == 1 and vim.fn.readfile(root_file)[1] or nil
      local slots = {}
      for entry, etype in vim.fs.dir(ws) do
        if etype == "directory" and entry:match("^slot%-%d+$") then
          local lock = vim.fs.joinpath(ws, entry .. ".lock")
          local state = "free"
          if uv.fs_lstat(lock) then
            state = is_live(lock) and ("in use by nvim " .. uv.fs_readlink(lock)) or "stale"
          end
          slots[vim.fs.joinpath(ws, entry)] = state
        end
      end
      fn(ws, root, slots)
    end
  end
end

--- `:KotlinLspSlots` lists slots; `:KotlinLspSlots clean` removes stale locks
--- and the caches of workspaces that no longer exist.
---@param arg string
function M.command(arg)
  local lines = {}
  each_workspace(function(ws, root, slots)
    if arg == "clean" then
      local live = false
      for slot, state in pairs(slots) do
        if state == "stale" then
          os.remove(slot .. ".lock")
          lines[#lines + 1] = "removed stale lock " .. slot .. ".lock"
        elseif state ~= "free" then
          live = true
        end
      end
      if not live and (not root or vim.fn.isdirectory(root) == 0) then
        vim.fn.delete(ws, "rf")
        lines[#lines + 1] = ("removed %s (workspace %s gone)"):format(ws, root or "unknown")
      end
    else
      lines[#lines + 1] = root or ws
      for slot, state in vim.spairs(slots) do
        lines[#lines + 1] = ("  %s  %s"):format(vim.fs.basename(slot), state)
      end
    end
  end)
  if #lines == 0 then
    lines[1] = arg == "clean" and "nothing to clean" or ("no kotlin-lsp slots under " .. BASE)
  end
  vim.notify(table.concat(lines, "\n"))
end

return M
