local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " " -- Make sure to set mapleader before lazy so your mappings are correct

local utils = require("ld.utils.functions")
return require("lazy").setup({

  "tpope/vim-rsi",
  "MunifTanjim/nui.nvim", -- ui library
  {
    "stevearc/dressing.nvim",
    config = function()
      require("ld.plugins.dressing")
    end,
  },

  -- allow commenting blocks with gcc
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "danymat/neogen",
    config = function()
      require("ld.plugins.neogen")
    end,
  },

  -- git client
  "tpope/vim-fugitive",
  {
    -- Adds commands :DiffviewFileHistory and :DiffviewOpen [git ref]
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("diffview").setup({})
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("ld.plugins.gitsigns")
    end,
  },
  -- makes vim follow symlinks, makes vim-fugitive work proerly with symlinks
  { "aymericbeaumet/vim-symlink" },

  {
    "tyru/open-browser.vim",
    config = function()
      require("ld.plugins.open-browser")
    end,
  },

  {
    "vimwiki/vimwiki",
    config = function()
      require("ld.plugins.vim-wiki")
    end,
  },

  -- PlantUML
  "weirongxu/plantuml-previewer.vim",
  "aklt/plantuml-syntax",

  -- Debugging
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { { "mfussenegger/nvim-dap" } },
    config = function()
      require("ld.plugins.dap")
    end,
  },

  -- color theme
  "Mofiqul/vscode.nvim",
  "NTBBloodbath/doom-one.nvim",
  -- use 'martinsione/darkplus.nvim'
  -- use("LunarVim/darkplus.nvim")
  -- use("tiagovla/tokyodark.nvim")
  "folke/tokyonight.nvim",
  "ellisonleao/gruvbox.nvim",
  -- alternative onedark for nvim ful1e5/onedark.nvim
  -- use("joshdick/onedark.vim")
  "tanvirtin/monokai.nvim",
  -- use("rebelot/kanagawa.nvim")
  -- use("yashguptaz/calvera-dark.nvim")
  -- use("projekt0n/github-nvim-theme")
  "olimorris/onedarkpro.nvim",
  "martinda/Jenkinsfile-vim-syntax",
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "less", "css", "scss" })
    end,
  },

  "szw/vim-maximizer",
  "mbbill/undotree",

  "kassio/neoterm",
  {
    "akinsho/toggleterm.nvim",
    branch = "main",
    config = function()
      require("ld.plugins.toggleterm")
    end,
  },

  -- icons
  "kyazdani42/nvim-web-devicons",

  {
    "kevinhwang91/nvim-bqf",
    config = function()
      require("ld.plugins.nvim-bqf")
    end,
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      search = {
        multi_window = false,
      },
      label = {
        style = "inline",
        before = true,
        after = false,
      },
      modes = {
        char = {
          highlight = { backdrop = false },
        },
      },
    },
  -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  "tpope/vim-repeat", -- extends . repeat, for example for make it work with vim-sneak
  "tpope/vim-surround", -- Change surrounding arks
  "wellle/targets.vim",

  {
    "rmagatti/auto-session",
    config = function()
      require("ld.plugins.auto-session")
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/popup.nvim" },
      { "nvim-lua/plenary.nvim" },
      -- on windows make and gcc need to be installed via scoop
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-live-grep-args.nvim",
      "ThePrimeagen/harpoon",
    },
    config = function()
      require("ld.plugins.telescope")
    end,
  },

  {
    "AckslD/nvim-neoclip.lua",
    cond = utils.is_linux(),
    dependencies = {
      { "tami5/sqlite.lua", module = "sqlite" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("neoclip").setup({ enable_persistent_history = true })
    end,
  },

  {
    "ibhagwan/fzf-lua",
    dependencies = {
      "kyazdani42/nvim-web-devicons", -- optional for icons
      "vijaymarupudi/nvim-fzf",
    },
    config = function()
      require("ld.plugins.fzf")
    end,
  },

  "gennaro-tedesco/nvim-peekup", -- shows register preview

  {
    "folke/which-key.nvim",
    config = function()
      require("ld.plugins.which-key")
    end,
  },

  {
    "goolord/alpha-nvim",
    config = function()
      require("ld.plugins.alpha")
    end,
  },

  {
    "kyazdani42/nvim-tree.lua",
    config = function()
      require("ld.plugins.nvim-tree")
    end,
  },

  {
    "ThePrimeagen/harpoon",
    config = function()
      require("ld.plugins.harpoon")
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Autocomplete & Linters
  "neovim/nvim-lspconfig",
  "tjdevries/lsp_extensions.nvim",
  "tami5/lspsaga.nvim",
  "onsails/lspkind-nvim",
  { "ray-x/lsp_signature.nvim", version = "v0.2.0" },
  "jose-elias-alvarez/typescript.nvim",
  "folke/neodev.nvim",
  "simrat39/rust-tools.nvim",
  "b0o/SchemaStore.nvim",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "jayp0521/mason-null-ls.nvim",
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({})
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("ld.lsp.servers.null-ls")
    end,
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  },
  {
    "mfussenegger/nvim-jdtls",
    config = function()
      require("ld.lsp.servers.jdtls")
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("ld.plugins.nvim-cmp")
    end,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-cmdline",
      "joshzcold/cmp-jenkinsfile",
      {
        "windwp/nvim-autopairs",
        config = function()
          require("ld.plugins.nvim-autopairs")
        end,
      },
    },
  },

  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("ld.plugins.snippets")
    end,
  },

  -- Language packs
  "mattn/emmet-vim",
  {
    "Everduin94/nvim-quick-switcher",
    config = function()
      require("ld.plugins.nvim-quick-switcher")
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("ld.plugins.treesitter")
    end,
    build = function()
      vim.cmd([[TSUpdate]])
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-refactor",
      "windwp/nvim-ts-autotag",
      "mrjones2014/nvim-ts-rainbow",
      "nvim-treesitter/playground",
      "andymass/vim-matchup",
      {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
          require("ld.plugins.treesitter-context")
        end,
      },
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
          require("ld.plugins.treesitter-textobjects")
        end,
      },
    },
  },

  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("ld.plugins.refactoring")
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons", lazy = true },
    config = function()
      require("ld.plugins.lualine-config")
    end,
  },
})
