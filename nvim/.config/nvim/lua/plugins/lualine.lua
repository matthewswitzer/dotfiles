-----------------------------------------------------------
-- Lualine Configuration
-----------------------------------------------------------

require('lualine').setup {
    sections = {
        lualine_c = {
            {
                'filename',
                symbols = {
                    modified = '󰏫',
                    readonly = '󰌾',
                },
            },
        },
        lualine_y = { 'os.date("%a %b %d %I:%M %p")' },
    },
    extensions = {
        'neo-tree',
        'nvim-dap-ui',
    },
}
