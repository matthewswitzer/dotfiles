-----------------------------------------------------------
-- Treesitter Configuration
-----------------------------------------------------------

return {

    -- treesitter integration
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
        init = function(plugin)
            require('lazy.core.loader').add_to_rtp(plugin)
            require 'nvim-treesitter.query_predicates'
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
        opts = {
            ensure_installed = {
                'bash',
                'css',
                'dockerfile',
                'gitignore',
                'html',
                'http',
                'ini',
                'javascript',
                'jsdoc',
                'json',
                'jsonc',
                'lua',
                'markdown',
                'python',
                'regex',
                'scss',
                'sql',
                'toml',
                'tsx',
                'typescript',
                'vim',
                'vimdoc',
                'yaml',
            },
            sync_install = false,
            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
        end,
    },

    -- sticky scroll
    {
        'nvim-treesitter/nvim-treesitter-context',
        event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
        opts = {
            max_lines = 2,
        },
    },
}
