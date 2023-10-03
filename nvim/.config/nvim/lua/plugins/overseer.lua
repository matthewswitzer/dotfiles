-----------------------------------------------------------
-- Overseer Configuration
-----------------------------------------------------------

require('overseer').setup {
    task_list = {
        direction = 'right',
    },
    form = {
        win_opts = {
            winblend = vim.o.winblend,
        },
    },
    confirm = {
        win_opts = {
            winblend = vim.o.winblend,
        },
    },
    task_win = {
        win_opts = {
            winblend = vim.o.winblend,
        },
    },
}
