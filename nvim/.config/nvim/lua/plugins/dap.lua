-----------------------------------------------------------
-- Debug Adapter Protocol (DAP) Configuration
-----------------------------------------------------------

return {

    -- dap client
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            'rcarriga/nvim-dap-ui',
            'theHamsta/nvim-dap-virtual-text',
            'mfussenegger/nvim-dap-python',
            'mxsdev/nvim-dap-vscode-js',
            {
                'microsoft/vscode-js-debug',
                build = 'npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out',
            },
        },
        keys = {
            {
                '<Leader>dj',
                "<Cmd>lua require('dap').continue()<CR>",
                desc = 'Start/Continue Debugging',
            },
            {
                '<Leader>dk',
                "<Cmd>lua require('dap').step_over()<CR>",
                desc = 'Step Over',
            },
            {
                '<Leader>dl',
                "<Cmd>lua require('dap').step_into()<CR>",
                desc = 'Step Into',
            },
            { '<Leader>dh', "<Cmd>lua require('dap').step_out()<CR>", desc = 'Step Out' },
            {
                '<Leader>dp',
                "<Cmd>lua require('dap').toggle_breakpoint()<CR>",
                desc = 'Toggle Breakpoint',
            },
            {
                '<Leader>dP',
                "<Cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
                desc = 'Set Breakpoint Condition',
            },
            {
                '<Leader>dL',
                "<Cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
                desc = 'Set Log Point Message',
            },
            {
                '<Leader>dd',
                "<Cmd>lua require('dap').clear_breakpoints()<CR>",
                desc = 'Clear Breakpoints',
            },
            {
                '<Leader>dr',
                "<Cmd>lua require('dap').repl.toggle()<CR>",
                desc = 'Toggle DAP REPL',
            },
            { '<Leader>dt', '<Cmd>DapOpenDebugTab<CR>', desc = 'Open Debug Tab' },
            { '<Leader>dT', '<Cmd>DapCloseDebugTab<CR>', desc = 'Close Debug Tab' },
            {
                '<Leader>dJ',
                "<Cmd>lua require('dap').run_last()<CR>",
                desc = 'Run Last Debug Adapter',
            },
            {
                '<Leader>dc',
                "<Cmd>lua require('dap').terminate()<CR>",
                desc = 'Terminate Debug Session',
            },
            { '<Leader>dv', '<Cmd>DapLoadLaunchJson<CR>', desc = 'Load launch.json' },
        },
        init = function()
            vim.fn.sign_define(
                'DapBreakpoint',
                { text = '', texthl = 'DiagnosticSignError' }
            )
            vim.fn.sign_define(
                'DapBreakpointCondition',
                { text = '', texthl = 'DiagnosticSignError' }
            )
            vim.fn.sign_define(
                'DapLogPoint',
                { text = '', texthl = 'DiagnosticSignWarn' }
            )
            vim.fn.sign_define(
                'DapStopped',
                { text = '', texthl = 'DiagnosticSignInfo' }
            )
            vim.fn.sign_define(
                'DapBreakpointRejected',
                { text = '', texthl = 'DiagnosticSignError' }
            )
        end,
        config = function()
            local dap = require 'dap'
            local dapui = require 'dapui'

            -- Python adapter
            require('dap-python').setup(
                vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python'
            )

            -- JS/TS adapter
            require('dap-vscode-js').setup {
                debugger_path = vim.fn.stdpath 'data' .. '/lazy/vscode-js-debug',
                adapters = {
                    'pwa-node',
                    'pwa-chrome',
                },
            }

            -- Define :DapLoadLaunchJson so we can set our own type to filetype mapping
            vim.api.nvim_create_user_command('DapLoadLaunchJson', function()
                require('dap.ext.vscode').load_launchjs(nil, {
                    ['pwa-node'] = { 'javascript', 'typescript' },
                    ['pwa-chrome'] = { 'javascript', 'typescript' },
                })
            end, { nargs = 0 })

            -- Setup DAP UI
            dapui.setup {}

            -- Open DAP UI in a new tab
            local debug_win = nil
            local debug_tab = nil
            local debug_tabnr = nil

            local function open_debug_tab()
                if debug_win and vim.api.nvim_win_is_valid(debug_win) then
                    vim.api.nvim_set_current_win(debug_win)
                    return
                end

                vim.cmd 'tabedit %'
                debug_win = vim.fn.win_getid()
                debug_tab = vim.api.nvim_win_get_tabpage(debug_win)
                debug_tabnr = vim.api.nvim_tabpage_get_number(debug_tab)

                dapui.open()
            end

            local function close_debug_tab()
                dapui.close()

                if debug_tab and vim.api.nvim_tabpage_is_valid(debug_tab) then
                    vim.api.nvim_exec('tabclose ' .. debug_tabnr, false)
                end

                debug_win = nil
                debug_tab = nil
                debug_tabnr = nil
            end

            -- Create commands we can call to open/close the debug tab
            vim.api.nvim_create_user_command(
                'DapOpenDebugTab',
                open_debug_tab,
                { bang = true }
            )
            vim.api.nvim_create_user_command(
                'DapCloseDebugTab',
                close_debug_tab,
                { bang = true }
            )

            -- Automatically open and close DAP UI
            ---@diagnostic disable-next-line: undefined-field
            dap.listeners.after.event_initialized['dapui_config'] = function()
                open_debug_tab()
            end
            ---@diagnostic disable-next-line: undefined-field
            dap.listeners.before.event_terminated['dapui_config'] = function()
                close_debug_tab()
            end
            ---@diagnostic disable-next-line: undefined-field
            dap.listeners.before.event_exited['dapui_config'] = function()
                close_debug_tab()
            end

            -- Setup virtual text
            require('nvim-dap-virtual-text').setup {}
        end,
    },
}
