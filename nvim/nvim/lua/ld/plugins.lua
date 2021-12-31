-- local present, packer = pcall(require, 'ld.packer_init')
-- if not present then return false end
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({
        'git', 'clone', '--depth', '1',
        'https://github.com/wbthomason/packer.nvim', install_path
    })
end

local useBuiltInLsp = true

return require('packer').startup(function(use)
    use({'wbthomason/packer.nvim', event = 'VimEnter'})
    use "lewis6991/impatient.nvim"

    use 'MunifTanjim/nui.nvim' -- ui library

    use 'editorconfig/editorconfig-vim'

    -- allow commenting blocks with gcc
    use {
        'numToStr/Comment.nvim',
        config = function() require('Comment').setup() end
    }

    -- git client
    use "tpope/vim-fugitive"

    use {
        -- Adds commands :DiffviewFileHistory and :DiffviewOpen [git ref]
        'sindrets/diffview.nvim',
        requires = 'nvim-lua/plenary.nvim',
        config = function() require('diffview').setup({}) end
    }

    use "dbeniamine/cheat.sh-vim"
    use {
        "tyru/open-browser.vim",
        config = function() require("ld.plugins.open-browser") end
    }
    use {
        "MattesGroeger/vim-bookmarks",
        config = function() require('ld.plugins.vim-bookmarks') end
    }
    use {
        "vimwiki/vimwiki",
        config = function() require('ld.plugins.vim-wiki') end
    }

    -- Debugging
    use {
        'puremourning/vimspector',
        config = function() require 'ld.plugins.vimspector' end
    }

    -- color theme
    use 'martinsione/darkplus.nvim'
    use 'folke/tokyonight.nvim'
    use 'Mofiqul/dracula.nvim'
    use 'EdenEast/nightfox.nvim'
    use 'sainnhe/gruvbox-material'
    use 'joshdick/onedark.vim'
    use({"catppuccin/nvim", as = "catppuccin"})
    use {'rose-pine/neovim', as = 'rose-pine'}
    use {'ray-x/aurora'}
    use 'tanvirtin/monokai.nvim'
    use "rebelot/kanagawa.nvim"

    use 'martinda/Jenkinsfile-vim-syntax'
    use {
        'norcalli/nvim-colorizer.lua',
        config = function() require'colorizer'.setup() end
    }

    use 'szw/vim-maximizer'

    use 'kassio/neoterm'

    -- icons
    use 'kyazdani42/nvim-web-devicons'

    use {
        'kevinhwang91/nvim-bqf',
        config = function() require 'ld.plugins.nvim-bqf' end
    }

    use {
        'justinmk/vim-sneak',
        config = function() require 'ld.plugins.sneak' end
    }

    use 'tpope/vim-repeat' -- extends . repeat, for example for make it work with vim-sneak
    use 'tpope/vim-surround' -- Change surrounding arks
    use 'wellle/targets.vim'

    use {
        'rmagatti/auto-session',
        config = function() require('ld.plugins.auto-session') end
    }

    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
        config = function() require 'ld.plugins.telescope' end
    }
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}

    use {
        "AckslD/nvim-neoclip.lua",
        requires = {
            {'tami5/sqlite.lua', module = 'sqlite'},
            {'nvim-telescope/telescope.nvim'}
        },
        config = function()
            require('neoclip').setup({enable_persistant_history = true})
        end
    }

    use {
        'ibhagwan/fzf-lua',
        requires = {
            'kyazdani42/nvim-web-devicons', -- optional for icons
            'vijaymarupudi/nvim-fzf'
        },
        config = function() require("ld.plugins.fzf") end
    }

    use 'gennaro-tedesco/nvim-peekup' -- shows register preview

    use {
        "folke/which-key.nvim",
        config = function() require("ld.plugins.which-key") end
    }

    use 'vifm/vifm.vim'

    use {
        'goolord/alpha-nvim',
        config = function() require('ld.plugins.alpha') end
    }

    use {
        'kyazdani42/nvim-tree.lua',
        tag = "1.6.7",
        config = function() require 'ld.plugins.nvim-tree' end
    }

    use {
        'lazytanuki/nvim-mapper',
        config = function() require 'ld.plugins.nvim-mapper' end,
        before = 'telescope.nvim'
    }

    use {
        'ThePrimeagen/harpoon',
        config = function() require 'ld.plugins.harpoon' end,
        requires = {"nvim-lua/plenary.nvim"}
    }
    -- use {
    --   'ray-x/navigator.lua',
    --   requires = {'ray-x/guihua.lua', run = 'cd lua/fzy && make'},
    -- }

    -- Autocomplete & Linters
    if useBuiltInLsp then

        use 'prettier/vim-prettier'
        use 'neovim/nvim-lspconfig'
        use 'nvim-lua/lsp-status.nvim'
        use 'tjdevries/lsp_extensions.nvim'
        use 'tami5/lspsaga.nvim'
        use 'onsails/lspkind-nvim'
        use 'ray-x/lsp_signature.nvim'
        use 'jose-elias-alvarez/nvim-lsp-ts-utils'
        use 'b0o/SchemaStore.nvim'
        use 'williamboman/nvim-lsp-installer'
        use({
            "jose-elias-alvarez/null-ls.nvim",
            config = function() require('ld.lsp.servers.null-ls') end,
            requires = {"nvim-lua/plenary.nvim", "neovim/nvim-lspconfig"}
        })

        use {
            'hrsh7th/nvim-cmp',
            config = function() require 'ld.plugins.nvim-cmp' end,
            event = 'InsertEnter'
        }

        use 'L3MON4D3/LuaSnip'

        use({'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp'})

        use({'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp'})

        use({'hrsh7th/cmp-buffer', after = 'nvim-cmp'})

        use({'hrsh7th/cmp-path', after = 'nvim-cmp'})

        use({'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp'})

        use({'hrsh7th/cmp-cmdline', after = 'nvim-cmp'})

        use({
            'windwp/nvim-autopairs',
            after = 'nvim-cmp',
            config = function() require('ld.plugins.nvim-autopairs') end
        })

    else
        -- using CoC
        use {
            "neoclide/coc.nvim",
            branch = "release",
            config = function() require("ld.plugins.coc") end
        }
        use "rafcamlet/coc-nvim-lua"

        use {"fannheyward/telescope-coc.nvim"}

    end
    -- Language packs

    use 'mattn/emmet-vim'
    use {
        "softoika/ngswitcher.vim",
        config = function() require("ld.plugins.ngswitcher") end
    }
    use {
        'nvim-treesitter/nvim-treesitter',
        config = function() require 'ld.plugins.treesitter' end,
        run = function() vim.cmd [[TSUpdate]] end
    }

    use {"nvim-treesitter/nvim-treesitter-refactor", after = "nvim-treesitter"}
    use {"windwp/nvim-ts-autotag", after = "nvim-treesitter"}
    use {"p00f/nvim-ts-rainbow", after = "nvim-treesitter"}
    use {"nvim-treesitter/nvim-treesitter-angular", after = "nvim-treesitter"}

    use {
        'nvim-treesitter/nvim-treesitter-textobjects',
        config = function() require 'ld.plugins.treesitter-textobjects' end,
        after = "nvim-treesitter"
    }

    -- use {
    --   "ThePrimeagen/refactoring.nvim",
    --   config = function() require("ld.plugins.refactoring") end,
    --   requires = {{"nvim-lua/plenary.nvim"}, {"nvim-treesitter/nvim-treesitter"}}
    -- }

    use {
        'nvim-lualine/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true},
        config = function() require('ld.plugins.lualine-config') end
    }

    -- Automatically set up you configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then require('packer').sync() end
end)

