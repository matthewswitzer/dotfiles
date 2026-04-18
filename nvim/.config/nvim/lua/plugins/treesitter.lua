-----------------------------------------------------------
-- Treesitter Configuration
-----------------------------------------------------------

return {

    -- treesitter integration
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        lazy = false,
        build = ':TSUpdate',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        opts = {
            ensure_installed = {
                'awk',
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
                'latex',
                'lua',
                'markdown',
                'markdown_inline',
                'python',
                'r',
                'regex',
                'scss',
                'sql',
                'toml',
                'tsx',
                'typescript',
                'typst',
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
                disable = { 'python' },
            },
        },
    },

    -- sticky scroll
    {
        'nvim-treesitter/nvim-treesitter-context',
        event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
        opts = {
            max_lines = 2,
        },
    },

    -- markdown preview
    {
        'OXY2DEV/markview.nvim',
        lazy = false,
        priority = 49,
        keys = {
            {
                '<Leader>m',
                '<Cmd>Markview Toggle<CR>',
                desc = 'Toggle Markdown Preview',
            },
        },
        opts = {
            preview = {
                icon_provider = 'nvim-web-devicons',
            },
        },
    },
}
