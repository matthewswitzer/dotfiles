-----------------------------------------------------------
-- Packer Configuration
-----------------------------------------------------------

-- Sync plugins after saving this file
vim.cmd [[
    augroup pluginSync
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]]

-----------------------------------------------------------
-- Plugin setup
-----------------------------------------------------------
return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- colorscheme
    use 'navarasu/onedark.nvim'

    -- icons
    use 'nvim-tree/nvim-web-devicons'

    -- statusline
    use 'nvim-lualine/lualine.nvim'

    -- buffer deleter
    use 'famiu/bufdelete.nvim'

    -- bufferline
    use { 'akinsho/bufferline.nvim', tag = 'v2.*' }

    -- file explorer
    use {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v2.x',
        requires = {
            'nvim-lua/plenary.nvim',
            'MunifTanjim/nui.nvim',
        },
    }

    -- terminal
    use 'numToStr/FTerm.nvim'

    -- fuzzy finder
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
            { 'nvim-telescope/telescope-live-grep-args.nvim' },
        },
    }

    -- treesitter interface
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            require('nvim-treesitter.install').update { with_sync = true }
        end,
    }

    -- tresitter context
    use {
        'nvim-treesitter/nvim-treesitter-context',
        config = function()
            require('treesitter-context').setup {}
        end,
    }

    -- vim.ui patches
    use 'stevearc/dressing.nvim'

    -- vim.notify ui
    use 'rcarriga/nvim-notify'

    -- highlight args
    use 'm-demare/hlargs.nvim'

    -- jump to location
    use {
        'phaazon/hop.nvim',
        branch = 'v2',
        config = function()
            require('hop').setup {}
        end,
    }

    -- clipboard management
    use {
        'AckslD/nvim-neoclip.lua',
        config = function()
            require('neoclip').setup {}
        end,
    }

    -- git status
    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup {}
        end,
    }

    -- commenting
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup {}
        end,
    }

    -- autopairs
    use 'windwp/nvim-autopairs'

    -- surround selection
    use {
        'kylechui/nvim-surround',
        tag = '*',
        config = function()
            require('nvim-surround').setup {}
        end,
    }

    -- indentation guides
    use 'lukas-reineke/indent-blankline.nvim'

    -- editorconfig support
    use 'gpanders/editorconfig.nvim'

    -- markdown preview
    use 'ellisonleao/glow.nvim'

    -- task runner
    use 'stevearc/overseer.nvim'

    -- test runner
    use {
        'nvim-neotest/neotest',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
            'antoinemadec/FixCursorHold.nvim',
            'haydenmeade/neotest-jest',
            'nvim-neotest/neotest-python',
        },
    }

    -- lsp
    use {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        'neovim/nvim-lspconfig',
        'b0o/schemastore.nvim',
    }

    -- efm-ls configs
    use {
        'creativenull/efmls-configs-nvim',
        tag = 'v1.*',
    }

    -- autocompletion
    use {
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
        'rafamadriz/friendly-snippets',
        'onsails/lspkind.nvim',
    }

    -- dap
    use {
        'mfussenegger/nvim-dap',
        'rcarriga/nvim-dap-ui',
        'theHamsta/nvim-dap-virtual-text',
    }

    -- javascript debug adapter
    use 'mxsdev/nvim-dap-vscode-js'
    use {
        'microsoft/vscode-js-debug',
        opt = true,
        run = 'npm install --legacy-peer-deps && npm run compile',
    }

    -- python debug adapter
    use 'mfussenegger/nvim-dap-python'
end)
