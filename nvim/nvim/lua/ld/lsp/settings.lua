-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup({
  setup_jsonls = false,
  plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
})

local lsp = require("lspconfig")
local functions = require("ld.lsp.functions")
local presentCmpNvimLsp, cmpNvimLsp = pcall(require, "cmp_nvim_lsp")

require("mason").setup({})
require("mason-null-ls").setup({
  ensure_installed = { "cspell", "stylua", "shfmt", "shellcheck", "prettierd", "yamllint" },
})
require("mason-lspconfig").setup({
  ensure_installed = {
    "bashls",
    "yamlls",
    "jsonls",
    "html",
    "cssls",
    "eslint",
    "lua_ls",
    "tsserver",
    "angularls",
  },
})

M = {}

-- for debugging lsp
-- Levels by name: 'trace', 'debug', 'info', 'warn', 'error'
vim.lsp.set_log_level("error")

vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    -- virtual_text = {spacing = 0, prefix = '■'},

    -- see: ":help vim.lsp.diagnostic.set_signs()"
    signs = true,

    update_in_insert = false,
  })
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  -- Use a rounded border with `FloatBorder` highlights
  border = "rounded",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  -- Use a rounded border with `FloatBorder` highlights
  border = "rounded",
})

local capabilities =
  { textDocument = { completion = { completionItem = { snippetSupport = true } } } }

if presentCmpNvimLsp then
  capabilities = vim.tbl_extend("keep", capabilities, cmpNvimLsp.default_capabilities())
end

M.capabilities = capabilities

local default_lsp_config = { capabilities }

local sumneko_lua_config = function()
  return {
    autostart = false,
    capabilities = capabilities,
    settings = {
      Lua = {
        format = {
          enable = false, -- null-ls handles the formatting
        },
      },
    },
  }
end

local clangd_config = function()
  local cloned_capabilities = vim.deepcopy(capabilities)
  cloned_capabilities.offsetEncoding = { "utf-16" }
  return { capabilities = cloned_capabilities }
end

local css_config = function()
  local cloned_capabilities = vim.deepcopy(capabilities)
  cloned_capabilities.textDocument.completion.completionItem.snippetSupport = true
  return { capabilities = cloned_capabilities }
end

local html_config = function()
  local cloned_capabilities = vim.deepcopy(capabilities)
  cloned_capabilities.textDocument.completion.completionItem.snippetSupport = true
  return {
    capabilities = cloned_capabilities,
    init_options = { provideFormatter = false, format = { enable = false } },
  }
end

local json_config = function()
  local cloned_capabilities = vim.deepcopy(capabilities)
  cloned_capabilities.textDocument.completion.completionItem.snippetSupport = true
  return {
    capabilities = cloned_capabilities,
    init_options = { provideFormatter = false, format = { enable = false } },
    settings = {
      json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } },
    },
  }
end

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

local angular_config = function()
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
  }
end

local deno_config = function()
  return {
    root_dir = lsp.util.root_pattern("deno.json"),
    init_options = { lint = true },
  }
end

local servers = {
  bashls = {},
  yamlls = {},
  jsonls = json_config(),
  html = html_config(),
  clangd = clangd_config(),
  cssls = css_config(),
  dockerls = {},
  eslint = {
    root_dir = lsp.util.root_pattern("tsconfig.json"),
    -- Refer to https://github.com/Microsoft/vscode-eslint#settings-options for documentation.
    settings = {
      workingDirectory = { mode = "location" },
      format = false,
    },
  },
  pylsp = {},
  gopls = {},
  lua_ls = sumneko_lua_config(),
  ltex = require("ld.lsp.servers.ltex").setup(),
  cmake = {},
}

if functions.is_deno_workspace() then
  servers.denols = deno_config()
else
  require("ld.lsp.servers.tsserver").setup()
  servers.angularls = angular_config()
end

require("ld.lsp.servers.rust-lsp").setup()

for serverName, config in pairs(servers) do
  lsp[serverName].setup(vim.tbl_deep_extend("force", default_lsp_config, config))
  vim.cmd([[ do User LspAttachBuffers ]])
end

return M
