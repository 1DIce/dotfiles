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
    lazy = false,   -- This plugin is already lazy
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
    "ldelossa/litee.nvim",
    event = "VeryLazy",
    opts = {
      notify = { enabled = false },
      panel = {
        orientation = "bottom",
        panel_size = 10,
      },
    },
    config = function(_, opts)
      require("litee.lib").setup(opts)
    end,
  },
  {
    "ldelossa/litee-calltree.nvim",
    dependencies = "ldelossa/litee.nvim",
    event = "VeryLazy",
    opts = {
      on_open = "panel",
      map_resize_keys = false,
    },
    config = function(_, opts)
      require("litee.calltree").setup(opts)
    end,
  },
  {
    "bassamsdata/namu.nvim",
    config = function()
      require("namu").setup({

        namu_symbols = {
          options = {
            AllowKinds = {
              rust = {
                "Function",
                "Method",
                "Module",
                "Property",
                "Variable",
                -- "Constant",
                "Enum",
                "Interface",
                -- "Field",
                "Struct",
              },
            },
            focus_current_symbol = false,
          },
        },
      })
    end,
  },
}
