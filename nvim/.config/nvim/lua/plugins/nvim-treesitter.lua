-----------------------------------------------------------
-- Treesitter Configuration
-----------------------------------------------------------

require('nvim-treesitter.configs').setup {
    ensure_installed = {
        'bash',
        'css',
        'dockerfile',
        'html',
        'http',
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
        'yaml',
    },
    sync_install = false,
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
}
