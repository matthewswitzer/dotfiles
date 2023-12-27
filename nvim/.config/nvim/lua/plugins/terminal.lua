-----------------------------------------------------------
-- Terminal Configuration
-----------------------------------------------------------

return {

    -- floating terminal
    {
        'numToStr/FTerm.nvim',
        keys = {
            -- Toggle the terminal with <C-t>
            { '<C-t>', '<Cmd>FTermToggle<CR>', desc = 'Toggle Terminal' },
            {
                '<C-t>',
                '<C-\\><C-n><Cmd>FTermToggle<CR>',
                mode = 't',
                desc = 'Toggle Terminal',
            },

            -- Close the terminal with <Esc>
            { '<Esc>', '<Cmd>FTermClose<CR>', mode = 't', desc = 'Close Terminal' },

            -- Toggle lazygit with <Leader>G
            { '<Leader>G', '<Cmd>LazygitToggle<CR>', desc = 'Toggle Lazygit' },

            -- Toggle lazydocker with <Leader>D
            { '<Leader>D', '<Cmd>LazydockerToggle<CR>', desc = 'Toggle Lazydocker' },

            -- Run code in current buffer with <Leader><Enter>
            {
                '<Leader><Enter>',
                '<Cmd>FTermRunCode<CR>',
                desc = 'Run Code in Current Buffer',
            },
        },
        opts = {
            blend = vim.o.winblend,
            border = 'rounded',
            dimensions = {
                height = 0.95,
                width = 0.965,
                x = 0.17,
                y = 0.35,
            },
        },
        config = function(_, opts)
            local command = vim.api.nvim_create_user_command

            -- :FTerm{Open,Close,Exit,Toggle}
            command('FTermOpen', require('FTerm').open, { bang = true })
            command('FTermClose', require('FTerm').close, { bang = true })
            command('FTermExit', require('FTerm').exit, { bang = true })
            command('FTermToggle', require('FTerm').toggle, { bang = true })

            -- :LazygitToggle
            command('LazygitToggle', function()
                require('FTerm')
                    :new(vim.tbl_extend('force', opts, {
                        ft = 'lazyterm',
                        cmd = 'lazygit',
                    }))
                    :toggle()
            end, { bang = true })

            -- :LazydockerToggle
            command('LazydockerToggle', function()
                require('FTerm')
                    :new(vim.tbl_extend('force', opts, {
                        ft = 'lazyterm',
                        cmd = 'lazydocker',
                    }))
                    :toggle()
            end, { bang = true })

            -- :FTermRunCode
            command('FTermRunCode', function()
                local runners = {
                    javascript = 'node',
                    python = 'python',
                }
                local buf = vim.api.nvim_buf_get_name(0)
                local ftype = vim.filetype.match { filename = buf }
                local exec = runners[ftype]
                if exec ~= nil then
                    require('FTerm').scratch { cmd = { exec, buf } }
                end
            end, { bang = true })

            -- Map `q` to quit and `<Esc>` to <Esc> on lazygit and lazydocker terminals
            vim.api.nvim_create_autocmd('TermOpen', {
                group = vim.api.nvim_create_augroup('FTerm', { clear = true }),
                callback = function(data)
                    local buf = data.buf
                    if vim.bo[buf].filetype == 'lazyterm' then
                        vim.keymap.set(
                            'n',
                            'q',
                            '<Cmd>close<CR>',
                            { buffer = buf, noremap = true, silent = true }
                        )
                        vim.keymap.set(
                            't',
                            '<Esc>',
                            '<Esc>',
                            { buffer = buf, noremap = true, silent = true }
                        )
                    end
                end,
            })

            require('FTerm').setup(opts)
        end,
    },

    -- task runner
    {
        'stevearc/overseer.nvim',
        keys = {
            -- Show available task to run with <Leader>t
            { '<Leader>t', '<Cmd>OverseerRun<CR>', desc = 'Show Tasks' },

            -- Show running tasks with <Leader>T
            { '<Leader>T', '<Cmd>OverseerToggle<CR>', desc = 'Show Running Tasks' },

            -- Re-run last task with <Leader>R
            { '<Leader>R', '<Cmd>OverseerRestartLast<CR>', desc = 'Restart Last Task' },
        },
        opts = {
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
        },
        config = function(_, opts)
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

            require('overseer').setup(opts)
        end,
    },
}
