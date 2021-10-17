local present, packer = pcall(require, 'lt.packer_init')

if not present then return false end

return packer.startup {
    function(use)
        use({'wbthomason/packer.nvim', event = 'VimEnter'})

        use 'MunifTanjim/nui.nvim' -- ui library


    use 'tomasiser/vim-code-dark'

    use 'nikvdp/neomux'
        -- icons
        use 'kyazdani42/nvim-web-devicons'

        use {
            'ahmedkhalf/project.nvim',
            config = function() require 'lt.plugins.project' end
        }

        use {
            'kevinhwang91/nvim-bqf',
            config = function() require 'lt.plugins.nvim-bqf' end
        }

        use {
            'justinmk/vim-sneak',
            config = function() require 'lt.plugins.sneak' end
        }


        use 'tpope/vim-surround' -- Change surrounding arks
        use 'tpope/vim-repeat' -- extends . repeat, for example for make it work with vim-sneak
        use {
            'bkad/CamelCaseMotion',
            config = function() require 'lt.plugins.camelcasemotion' end
        } -- allows to move by camelCase with w e

        use {
            'nvim-telescope/telescope.nvim',
            requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
            config = function() require 'lt.plugins.telescope' end
        }
        use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}

        use 'gennaro-tedesco/nvim-peekup' -- shows register preview

        use {
            'kyazdani42/nvim-tree.lua',
            config = function() require 'lt.plugins.nvim-tree' end
        }

        use {
            'lazytanuki/nvim-mapper',
            config = function() require 'lt.plugins.nvim-mapper' end,
            before = 'telescope.nvim'
        }

        -- Autocomplete & Linters
        use 'neovim/nvim-lspconfig'
        use 'nvim-lua/lsp-status.nvim'
        use 'tjdevries/lsp_extensions.nvim'
        use 'glepnir/lspsaga.nvim'
        use 'onsails/lspkind-nvim'
        use 'ray-x/lsp_signature.nvim'
        use 'jose-elias-alvarez/nvim-lsp-ts-utils'
        use 'williamboman/nvim-lsp-installer'


        use {
            'hrsh7th/nvim-cmp',
            config = function() require 'lt.plugins.nvim-cmp' end,
            event = 'InsertEnter'
        }

        use 'L3MON4D3/LuaSnip'

        use({'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp'})

        use({'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp'})

        use({'hrsh7th/cmp-buffer', after = 'nvim-cmp'})

        use({'hrsh7th/cmp-path', after = 'nvim-cmp'})

        use({'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp'})

        use({
            'windwp/nvim-autopairs',
            after = 'nvim-cmp',
            config = function() require('lt.plugins.nvim-autopairs') end
        })

        -- Language packs
        use {
            'nvim-treesitter/nvim-treesitter',
            config = function() require 'lt.plugins.treesitter' end,
            run = function() vim.cmd [[TSUpdate]] end
        }

        use {
            'SmiteshP/nvim-gps',
            requires = 'nvim-treesitter/nvim-treesitter',
            config = function() require 'lt.plugins.nvim-gps' end
        }

        use {
            'nvim-treesitter/nvim-treesitter-textobjects',
            config = function()
                require 'lt.plugins.treesitter-textobjects'
            end
        }

        -- status line
        use {
            'NTBBloodbath/galaxyline.nvim',
            requires = 'SmiteshP/nvim-gps',
            config = function() require 'lt.plugins.galaxyline' end
        }
    end
}
