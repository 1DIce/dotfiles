local M = {}

-- stylua: ignore
local INLAY_HINT_DEFAULTS = {
  enabled                    = false,  -- auto-enable inlay hints on attach
  parameters                 = true,  -- parameter name hints
  parameters_compiled        = false, -- hints for compiled code
  parameters_excluded        = false, -- exclude certain parameter hints
  types_property             = false, -- property type hints
  types_variable             = false, -- variable type hints
  function_return            = false, -- function return type hints
  function_parameter         = false, -- function parameter type hints
  lambda_return              = false, -- lambda return type hints
  lambda_receivers_parameters = false, -- lambda receiver/parameter hints
  value_ranges               = false, -- value range hints
  kotlin_time                = false, -- kotlin.time duration hints
}

-- Buffer versions when each rename request was sent, keyed "client:request".
local rename_snapshots = {} ---@type table<string, table<integer, integer>>

-- kotlin-lsp stamps rename edits with its own document version, not the one
-- Neovim sent, so any buffer edited since opening looks out of date. Neovim
-- would then skip that file's edits and apply the rest, leaving the symbol
-- half-renamed. The edits are also minimal diffs (e.g. "lick" -> ""), so
-- their ranges cannot be checked against the old name.
--
-- Instead, trust the edits for every buffer that has not changed since the
-- request was sent: the server saw the same text. If one has changed, apply
-- nothing, so a rename is never partial.
local function rename_handler(err, result, ctx)
  local snapshot = rename_snapshots[ctx.client_id .. ":" .. ctx.request_id] or {}
  rename_snapshots[ctx.client_id .. ":" .. ctx.request_id] = nil
  if err then
    if err.code == vim.lsp.protocol.ErrorCodes.ContentModified then
      vim.notify("kotlin-lsp: file changed during rename, try again", vim.log.levels.WARN)
    else
      vim.notify(
        "kotlin-lsp: rename failed: " .. tostring(err.message or err.code),
        vim.log.levels.ERROR
      )
    end
    return
  end
  if not result then
    vim.notify("kotlin-lsp: no rename result", vim.log.levels.INFO)
    return
  end

  for _, change in ipairs(result.documentChanges or {}) do
    local doc = change.textDocument
    if not change.kind and doc then
      local bufnr = vim.uri_to_bufnr(doc.uri)
      local sent = snapshot[bufnr]
      if sent and vim.lsp.util.buf_versions[bufnr] ~= sent then
        vim.notify(
          ("kotlin-lsp: %s changed during rename, nothing applied. Try again."):format(
            vim.fs.basename(doc.uri)
          ),
          vim.log.levels.WARN
        )
        return
      end
      doc.version = vim.NIL
    end
  end

  local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
  vim.lsp.util.apply_workspace_edit(result, client.offset_encoding)
end

-- Record buffer versions as each rename request is sent.
local function track_rename_requests(group)
  vim.api.nvim_create_autocmd("LspRequest", {
    group = group,
    callback = function(ev)
      local req = ev.data.request
      if req.method ~= "textDocument/rename" then
        return
      end
      local key = ev.data.client_id .. ":" .. ev.data.request_id
      if req.type == "pending" then
        rename_snapshots[key] = vim.deepcopy(vim.lsp.util.buf_versions)
      elseif req.type == "cancel" then
        rename_snapshots[key] = nil
      end
    end,
  })
end

function M.setup(opts)
  opts = opts or {}

  vim.api.nvim_create_augroup("kotlin_lsp_standalone", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "kotlin",
    group = "kotlin_lsp_standalone",
    once = true,
    callback = function()
      M._configure(opts)
    end,
  })
end

function M._configure(opts)
  track_rename_requests("kotlin_lsp_standalone")

  -- One kotlin-lsp --stdio process per Neovim instance. The launcher claims a
  -- free per-workspace cache slot (--system-path), since kotlin-lsp locks its
  -- index there; slots are reused so restarts start warm. Claude Code uses the
  -- same launcher. Pass root_dir so launcher and client agree on the workspace.
  local launcher = vim.fn.expand("~/dotfiles/scripts/kotlin-lsp-slot.sh")
  local cmd = function(dispatchers, config)
    return vim.lsp.rpc.start({ launcher, "run", config.root_dir }, dispatchers)
  end

  -- Settings
  local hints = opts.inlay_hints or INLAY_HINT_DEFAULTS
  local settings = {
    uri_timeout_ms = 5000,
    ["jetbrains.kotlin.hints.parameters"] = hints.parameters,
    ["jetbrains.kotlin.hints.parameters.compiled"] = hints.parameters_compiled,
    ["jetbrains.kotlin.hints.parameters.excluded"] = hints.parameters_excluded,
    ["jetbrains.kotlin.hints.settings.types.property"] = hints.types_property,
    ["jetbrains.kotlin.hints.settings.types.variable"] = hints.types_variable,
    ["jetbrains.kotlin.hints.type.function.return"] = hints.function_return,
    ["jetbrains.kotlin.hints.type.function.parameter"] = hints.function_parameter,
    ["jetbrains.kotlin.hints.settings.lambda.return"] = hints.lambda_return,
    ["jetbrains.kotlin.hints.lambda.receivers.parameters"] = hints.lambda_receivers_parameters,
    ["jetbrains.kotlin.hints.settings.value.ranges"] = hints.value_ranges,
    ["jetbrains.kotlin.hints.value.kotlin.time"] = hints.kotlin_time,
  }

  -- Register LSP config
  vim.lsp.config.kotlin_ls = {
    cmd = cmd,
    filetypes = { "kotlin" },
    -- Settings files first so multi-module projects resolve to the top-level root.
    root_markers = {
      { "settings.gradle.kts", "settings.gradle" },
      { "build.gradle.kts", "build.gradle", "pom.xml", "mvnw" },
    },
    settings = settings,
    capabilities = {
      textDocument = {
        inlayHint = {
          dynamicRegistration = true,
        },
      },
    },
    handlers = {
      ["textDocument/rename"] = rename_handler,
      ["workspace/configuration"] = function(err, params, ctx)
        local result = {}
        for _, item in ipairs(params.items or {}) do
          local section = item.section

          if section == "jetbrains.kotlin" then
            table.insert(result, {
              hints = {
                parameters = hints.parameters,
                ["parameters.compiled"] = hints.parameters_compiled,
                ["parameters.excluded"] = hints.parameters_excluded,
                settings = {
                  types = { property = hints.types_property, variable = hints.types_variable },
                  lambda = { ["return"] = hints.lambda_return },
                  value = { ranges = hints.value_ranges },
                },
                type = {
                  ["function"] = {
                    ["return"] = hints.function_return,
                    parameter = hints.function_parameter,
                  },
                },
                lambda = { receivers = { parameters = hints.lambda_receivers_parameters } },
                value = { kotlin = { time = hints.kotlin_time } },
              },
            })
          elseif section and settings[section] ~= nil then
            table.insert(result, settings[section])
          else
            table.insert(result, vim.NIL)
          end
        end
        return result
      end,
    },
  }

  vim.lsp.enable("kotlin_ls")

  -- Auto-enable inlay hints on attach
  if hints.enabled ~= false then
    vim.api.nvim_create_autocmd("LspAttach", {
      group = "kotlin_lsp_standalone",
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client.name == "kotlin_ls" then
          vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
        end
      end,
    })
  end
end

return M
