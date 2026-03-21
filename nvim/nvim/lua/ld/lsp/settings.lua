local functions = require("ld.lsp.functions")

require("mason").setup({})
require("mason-nvim-dap").setup({
  ensure_installed = { "codelldb" },
  handlers = {}, -- sets up dap in the predefined manner
})

require("mason-null-ls").setup(
  ---@diagnostic disable-next-line: missing-fields
  {
    ensure_installed = { "stylua", "shfmt", "shellcheck", "prettierd" },
  }
)
require("mason-lspconfig").setup({
  automatic_enable = false,
  ensure_installed = {
    "bashls",
    "yamlls",
    "jsonls",
    "html",
    "cssls",
    "eslint",
    "lua_ls",
    "vtsls", -- alternative typescript lsp
    "angularls",
    "docker_compose_language_service",
    "dockerls",
    "basedpyright",
  },
})

M = {}

-- for debugging lsp
-- Levels by name: 'trace', 'debug', 'info', 'warn', 'error'
vim.lsp.set_log_level("error")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities =
  vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))

capabilities =
  vim.tbl_deep_extend("force", capabilities, require("lsp-file-operations").default_capabilities())

M.capabilities = capabilities

local function get_node_modules(root_dir)
  -- util.find_node_modules_ancestor()
  local root_node = root_dir .. "/node_modules"
  local stats = vim.loop.fs_stat(root_node)
  if stats == nil then
    return nil
  else
    if require("ld.utils.functions").is_windows() then
      return vim.fn.substitute(root_node, "/", "\\\\", "g")
    else
      return root_node
    end
  end
end

local default_node_modules = get_node_modules(vim.fn.getcwd())

local function angular_config()
  local ngls_cmd = {
    "ngserver",
    "--stdio",
    "--tsProbeLocations",
    default_node_modules,
    "--ngProbeLocations",
    default_node_modules,
  }
  return {
    cmd = ngls_cmd,
    on_new_config = function(new_config)
      new_config.cmd = ngls_cmd
    end,
    filetypes = { "typescript", "angular.html", "typescriptreact", "typescript.tsx" },
    root_markers = { "angular.json" },
  }
end

local function deno_config()
  return {
    root_markers = { "deno.json" },
    init_options = { lint = true },
  }
end

require("ld.lsp.servers.cspell").setup()

local servers = {
  -- to get fromatting and linting shellcheck and shfmt need to be installed
  bashls = {},
  yamlls = {
    settings = {
      yaml = { customTags = {
        "!reference sequence",
      } },
      schemas = {
        ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "./.gitlab/ci/*",
      },
    },
  },
  jsonls = {
    init_options = { provideFormatter = false, format = { enable = false } },
    settings = {
      json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } },
    },
  },
  html = { init_options = { provideFormatter = false, format = { enable = false } } },
  cssls = {},
  dockerls = {},
  -- only starts up if the filetype is yaml.dockercompose `:set filetype=yaml.dockercompose`
  docker_compose_language_service = {},
  eslint = {

    root_markers = { "tsconfig.json" },
    -- Refer to https://github.com/Microsoft/vscode-eslint#settings-options for documentation.
    settings = {
      workingDirectory = { mode = "location" },
      format = false,
    },
  },
  gopls = require("ld.lsp.servers.gopls").setup(),
  lua_ls = {
    autostart = true,
    settings = {
      Lua = {
        format = {
          enable = false, -- null-ls handles the formatting
        },
      },
    },
  },
  ltex_plus = require("ld.lsp.servers.ltex").setup(),
  cmake = {},
  astro = {},
  terraformls = {},
  ruff = {
    -- python formatter
    cmd = { "uvx", "ruff", "server" },
    root_markers = { ".git" },
  },
  basedpyright = {
    capabilities = capabilities,
    root_markers = { ".git" },
  },
  -- pyrefly = {
  --   root_markers = { ".git" },
  --   capabilities = capabilities,
  -- },
  -- kotlin_language_server = {
  --   capabilities = capabilities,
  -- },
  kotlin_lsp = {
    capabilities = capabilities,
    cmd = { "kotlin-lsp", "--stdio" },
    filetypes = { "kotlin" },
    root_markers = {
      "settings.gradle",
      "settings.gradle.kts",
      "pom.xml",
      "build.gradle",
      "build.gradle.kts",
      "workspace.json",
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
      local orig = client.handlers["window/showDocument"]
        or vim.lsp.handlers["window/showDocument"]

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
  },
  just = {},
}

if functions.is_deno_workspace() then
  servers.denols = deno_config()
else
  require("lspconfig.configs").vtsls = require("vtsls").lspconfig -- set default server config, optional but recommended
  servers.vtsls = require("ld.lsp.servers.vtsls-typescript").setup()

  servers.angularls = angular_config()
end

require("ld.lsp.servers.rust-lsp").setup()

for serverName, config in pairs(servers) do
  vim.lsp.config(serverName, config)
  vim.lsp.enable(serverName, true)
end

require("ld.lsp.neotest")

return M
