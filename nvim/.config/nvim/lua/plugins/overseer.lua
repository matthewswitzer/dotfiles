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

-- Command to re-run last task
vim.api.nvim_create_user_command('OverseerRestartLast', function()
    local overseer = require 'overseer'
    local tasks = overseer.list_tasks { recent_first = true }
    if vim.tbl_isempty(tasks) then
        vim.notify('No tasks found', vim.log.levels.WARN)
    else
        overseer.run_action(tasks[1], 'restart')
    end
end, {})
