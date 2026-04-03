return {
  -- Autocomplete & Linters
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "antosha417/nvim-lsp-file-operations",
    },
  },

  "yioneko/nvim-vtsls",
  "onsails/lspkind-nvim",
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      -- disable when a .luarc.json file is found
      enabled = function(root_dir)
        return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
      end,
    },
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^6", -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  {
    "mfussenegger/nvim-jdtls",
  },
  {
    "ray-x/go.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    lazy = false,
    config = function()
      require("go").setup({
        lsp_cfg = false,
        lsp_keymaps = false,
        lsp_codelens = false,
        null_ls = false,
        lsp_inlay_hints = {
          enable = false,
        },
        gopls_remote_auto = false,
        dap_debug = false,
        dap_debug_keymap = false,
        dap_debug_gui = false,
        dap_debug_vt = false,

        verbose = false,
        textobjects = false,

        luasnip = false, -- relevant snippets are loaded in luasnips config file
      })
    end,
  },
  "b0o/SchemaStore.nvim",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        html = { "prettierd" },
        css = { "prettierd" },
        scss = { "prettierd" },
        less = { "prettierd" },
        json = { "prettierd" },
        jsonc = { "prettierd" },
        yaml = { "prettierd" },
        astro = { "prettierd" },
        sh = { "shfmt" },
      },
      format_on_save = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        local functions = require("ld.lsp.functions")

        if ft == "typescript" or ft == "typescriptreact" then
          functions.format_organize_typescript(bufnr)
        elseif ft == "python" then
          local client = vim.lsp.get_clients({ bufnr = bufnr, name = "ruff" })[1]
          if client then
            functions.run_code_action_sync("source.fixAll", bufnr, client)
          end
        end

        return { timeout_ms = 3000, lsp_format = "fallback" }
      end,
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("lint").linters_by_ft = {
        yaml = { "yamllint" },
        sh = { "shellcheck" },
      }

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("ld-nvim-lint", { clear = true }),
        callback = function(event)
          if vim.bo[event.buf].filetype == "helm" then
            return
          end
          require("lint").try_lint()
        end,
      })
    end,
  },
}
