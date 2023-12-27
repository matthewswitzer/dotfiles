-----------------------------------------------------------
-- User Interface Configuration
-----------------------------------------------------------

return {

    -- icons
    { 'nvim-tree/nvim-web-devicons', lazy = true },

    -- statusline
    {
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
        init = function()
            if vim.fn.argc(-1) > 0 then
                -- set an empty statusline until lualine loads
                vim.o.statusline = ' '
            else
                -- hide the statusline on the starter page
                vim.o.laststatus = 0
            end
        end,
        opts = {
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
        },
    },

    -- buffer remover
    {
        'famiu/bufdelete.nvim',
        cmd = 'Bdelete',
        keys = {
            -- Close current buffer with <Leader>w
            { '<Leader>w', '<Cmd>Bdelete!<CR>', desc = 'Close Current Buffer' },

            -- Close all but current buffer with <Leader>W
            {
                '<Leader>W',
                function()
                    local current = vim.api.nvim_get_current_buf()
                    local buffers = require('bufferline.utils').get_valid_buffers()

                    for _, bufnr in pairs(buffers) do
                        if bufnr ~= current then
                            vim.cmd('Bdelete! ' .. bufnr)
                        end
                    end
                end,
                desc = 'Close All But Current Buffer',
            },
        },
    },

    -- bufferline
    {
        'akinsho/bufferline.nvim',
        version = '*',
        event = 'VeryLazy',
        keys = {
            -- Cycle through buffers with ]b and [b
            { ']b', '<Cmd>BufferLineCycleNext<CR>', desc = 'Go to Next Buffer' },
            { '[b', '<Cmd>BufferLineCyclePrev<CR>', desc = 'Go to Prev Buffer' },

            -- Pick buffers with <Leader><Leader>p; pick close with <Leader><Leader>P
            {
                '<Leader><Leader>p',
                '<Cmd>BufferLinePick<CR>',
                desc = 'Pick Buffer to Open',
            },
            {
                '<Leader><Leader>P',
                '<Cmd>BufferLinePickClose<CR>',
                desc = 'Pick Buffer to Close',
            },

            -- Reorder buffers using <Leader>b{h,l}
            { '<Leader>bh', '<Cmd>BufferLineMovePrev<CR>', desc = 'Reorder Buffer Left' },
            {
                '<Leader>bl',
                '<Cmd>BufferLineMoveNext<CR>',
                desc = 'Reorder Buffer Right',
            },
        },
        opts = {
            options = {
                buffer_close_icon = '󰅖',
                close_command = 'Bdelete! %d',
                offsets = {
                    {
                        filetype = 'neo-tree',
                        text = 'File Explorer',
                        text_align = 'left',
                        highlight = 'BufferLineOffset',
                        padding = 1,
                    },
                },
            },
        },
        config = function(_, opts)
            require('bufferline').setup(opts)
        end,
    },

    -- file explorer
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v3.x',
        cmd = 'Neotree',
        dependencies = {
            'MunifTanjim/nui.nvim',
        },
        keys = {
            -- Toggle the file explorer with <Leader>e; focus with <Leader>E
            { '<Leader>e', '<Cmd>Neotree toggle<CR>', desc = 'Toggle Neotree' },
            { '<Leader>E', '<Cmd>Neotree focus<CR>', desc = 'Focus Neotree' },
        },
        deactivate = function()
            vim.cmd [[Neotree close]]
        end,
        init = function()
            if vim.fn.argc(-1) == 1 then
                local stat = vim.loop.fs_stat(vim.fn.argv(0))
                if stat and stat.type == 'directory' then
                    require 'neo-tree'
                end
            end
        end,
        opts = {
            default_component_configs = {
                modified = {
                    symbol = '󰏫',
                },
            },
            window = {
                width = 30,
            },
            filesystem = {
                filtered_items = {
                    hide_dotfiles = false,
                    never_show = {
                        '.DS_Store',
                        '.git',
                        '.venv',
                    },
                },
                follow_current_file = true,
                use_libuv_file_watcher = true,
            },
            sources = {
                'filesystem',
            },
        },
        config = function(_, opts)
            require('neo-tree').setup(opts)
        end,
    },

    -- vim.ui patches
    {
        'stevearc/dressing.nvim',
        lazy = true,
        ---@diagnostic disable-next-line: unused-vararg
        init = function(...)
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require('lazy').load { plugins = { 'dressing.nvim' } }
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require('lazy').load { plugins = { 'dressing.nvim' } }
                return vim.ui.input(...)
            end
        end,
    },

    -- vim.notify ui
    {
        'rcarriga/nvim-notify',
        event = 'VeryLazy',
        keys = {
            -- Dismiss all notifications with Q
            {
                'Q',
                function()
                    ---@diagnostic disable-next-line: undefined-field
                    require('notify').dismiss { silent = true, pending = true }
                end,
                desc = 'Dismiss Notifications',
            },

            -- Show notification history with <Leader>N
            { '<Leader>N', '<Cmd>Telescope notify<CR>', desc = 'Show Notifications' },
        },
        opts = {
            fps = 60,
            timeout = 3000,
            top_down = false,
        },
        config = function(_, opts)
            local notify = require 'notify'

            ---@diagnostic disable-next-line: undefined-field
            notify.setup(opts)

            vim.notify = notify
        end,
    },
}
