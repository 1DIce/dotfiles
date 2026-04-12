local M = {}

local function get_workspace_base_dir()
  local is_windows = vim.fn.has("win32") == 1
  if is_windows then
    local localappdata = os.getenv("LOCALAPPDATA")
      or (os.getenv("USERPROFILE") .. "\\AppData\\Local")
    return localappdata .. "\\kotlin-lsp-my-workspaces"
  else
    return os.getenv("HOME") .. "/.cache/kotlin-lsp-my-workspaces"
  end
end

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

-- stylua: ignore
local DEFAULT_JVM_ARGS = {
  "--add-opens", "java.base/java.io=ALL-UNNAMED",
  "--add-opens", "java.base/java.lang=ALL-UNNAMED",
  "--add-opens", "java.base/java.lang.ref=ALL-UNNAMED",
  "--add-opens", "java.base/java.lang.reflect=ALL-UNNAMED",
  "--add-opens", "java.base/java.net=ALL-UNNAMED",
  "--add-opens", "java.base/java.nio=ALL-UNNAMED",
  "--add-opens", "java.base/java.nio.charset=ALL-UNNAMED",
  "--add-opens", "java.base/java.text=ALL-UNNAMED",
  "--add-opens", "java.base/java.time=ALL-UNNAMED",
  "--add-opens", "java.base/java.util=ALL-UNNAMED",
  "--add-opens", "java.base/java.util.concurrent=ALL-UNNAMED",
  "--add-opens", "java.base/java.util.concurrent.atomic=ALL-UNNAMED",
  "--add-opens", "java.base/java.util.concurrent.locks=ALL-UNNAMED",
  "--add-opens", "java.base/jdk.internal.vm=ALL-UNNAMED",
  "--add-opens", "java.base/sun.net.dns=ALL-UNNAMED",
  "--add-opens", "java.base/sun.nio.ch=ALL-UNNAMED",
  "--add-opens", "java.base/sun.nio.fs=ALL-UNNAMED",
  "--add-opens", "java.base/sun.security.ssl=ALL-UNNAMED",
  "--add-opens", "java.base/sun.security.util=ALL-UNNAMED",
  "--add-opens", "java.desktop/com.apple.eawt=ALL-UNNAMED",
  "--add-opens", "java.desktop/com.apple.eawt.event=ALL-UNNAMED",
  "--add-opens", "java.desktop/com.apple.laf=ALL-UNNAMED",
  "--add-opens", "java.desktop/com.sun.java.swing=ALL-UNNAMED",
  "--add-opens", "java.desktop/com.sun.java.swing.plaf.gtk=ALL-UNNAMED",
  "--add-opens", "java.desktop/java.awt=ALL-UNNAMED",
  "--add-opens", "java.desktop/java.awt.dnd.peer=ALL-UNNAMED",
  "--add-opens", "java.desktop/java.awt.event=ALL-UNNAMED",
  "--add-opens", "java.desktop/java.awt.font=ALL-UNNAMED",
  "--add-opens", "java.desktop/java.awt.image=ALL-UNNAMED",
  "--add-opens", "java.desktop/java.awt.peer=ALL-UNNAMED",
  "--add-opens", "java.desktop/javax.swing=ALL-UNNAMED",
  "--add-opens", "java.desktop/javax.swing.plaf.basic=ALL-UNNAMED",
  "--add-opens", "java.desktop/javax.swing.text=ALL-UNNAMED",
  "--add-opens", "java.desktop/javax.swing.text.html=ALL-UNNAMED",
  "--add-opens", "java.desktop/sun.awt=ALL-UNNAMED",
  "--add-opens", "java.desktop/sun.awt.X11=ALL-UNNAMED",
  "--add-opens", "java.desktop/sun.awt.datatransfer=ALL-UNNAMED",
  "--add-opens", "java.desktop/sun.awt.image=ALL-UNNAMED",
  "--add-opens", "java.desktop/sun.awt.windows=ALL-UNNAMED",
  "--add-opens", "java.desktop/sun.font=ALL-UNNAMED",
  "--add-opens", "java.desktop/sun.java2d=ALL-UNNAMED",
  "--add-opens", "java.desktop/sun.lwawt=ALL-UNNAMED",
  "--add-opens", "java.desktop/sun.lwawt.macosx=ALL-UNNAMED",
  "--add-opens", "java.desktop/sun.swing=ALL-UNNAMED",
  "--add-opens", "java.management/sun.management=ALL-UNNAMED",
  "--add-opens", "jdk.attach/sun.tools.attach=ALL-UNNAMED",
  "--add-opens", "jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED",
  "--add-opens", "jdk.internal.jvmstat/sun.jvmstat.monitor=ALL-UNNAMED",
  "--add-opens", "jdk.jdi/com.sun.tools.jdi=ALL-UNNAMED",
  "--enable-native-access=ALL-UNNAMED",
  "-Djdk.lang.Process.launchMechanism=FORK",
}

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
  local is_windows = vim.fn.has("win32") == 1

  -- Workspace directory
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  local workspace_dir = get_workspace_base_dir() .. (is_windows and "\\" or "/") .. project_name
  vim.fn.mkdir(workspace_dir, "p")

  -- Build command
  local cmd = { "kotlin-lsp" }
  -- for _, arg in ipairs(DEFAULT_JVM_ARGS) do
  --   cmd[#cmd + 1] = arg
  -- end
  cmd[#cmd + 1] = "--stdio"
  cmd[#cmd + 1] = "--system-path=" .. workspace_dir

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
    root_markers = { "build.gradle", "build.gradle.kts", "pom.xml", "mvnw" },
    settings = settings,
    capabilities = {
      textDocument = {
        inlayHint = {
          dynamicRegistration = true,
        },
      },
    },
    handlers = {
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

    -- Workaround for cursor landing one char too far left after completion
    -- at end of line. See kotlin-lsp-completion-cursor-bug.md for full details.
    --
    -- The Kotlin LSP completes via a command rather than a textEdit:
    --   1. textEdit is a no-op (newText = "")
    --   2. command "jetbrains.kotlin.completion.apply" fires
    --   3. LSP sends workspace/applyEdit to insert the actual text
    --   4. LSP sends window/showDocument to position the cursor
    --
    -- Neovim's showDocument handler uses nvim_win_set_cursor which operates
    -- in normal-mode terms: it places cursor ON a character and clamps to the
    -- last char when the target is past EOL. In insert mode the cursor should
    -- be AFTER the last char (the append position), so clamping causes it to
    -- land one position too far left. This only manifests when completing at
    -- the end of a line with no trailing text.
    on_init = function(client)
      local orig = client.handlers["window/showDocument"] or vim.lsp.handlers["window/showDocument"]

      client.handlers["window/showDocument"] = function(err, result, ctx, config)
        -- Run the default handler first (opens file, sets cursor, etc)
        local resp = orig(err, result, ctx, config)

        local mode = vim.api.nvim_get_mode().mode
        if (mode == "i" or mode == "ic") and result and result.selection then
          local row = result.selection.start.line
          local col = result.selection.start.character

          -- Schedule so the buffer state reflects the workspace/applyEdit
          vim.schedule(function()
            -- Re-check mode since it may have changed between handler and schedule
            if vim.api.nvim_get_mode().mode:sub(1, 1) ~= "i" then
              return
            end

            local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1] or ""
            local cur = vim.api.nvim_win_get_cursor(0)

            -- If the LSP requested a position at/past EOL but nvim_win_set_cursor
            -- clamped the cursor short, nudge it to the actual end of line
            if col >= #line and cur[2] < #line then
              vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes("<End>", true, false, true),
                "n",
                false
              )
            end
          end)
        end

        return resp
      end
    end,
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
