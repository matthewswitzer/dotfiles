-----------------------------------------------------------
-- DAP Configuration
-----------------------------------------------------------

local dap = require 'dap'
local dapui = require 'dapui'
local dap_python = require 'dap-python'
local dap_vscode_js = require 'dap-vscode-js'
local dap_virtual_text = require 'nvim-dap-virtual-text'

-----------------------------------------------------------
-- Adapter setup
-----------------------------------------------------------

-- Python
dap_python.setup(vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python')

-- JavaScript/TypeScript
dap_vscode_js.setup {
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

-----------------------------------------------------------
-- DAP interface
-----------------------------------------------------------

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
vim.api.nvim_create_user_command('DapOpenDebugTab', open_debug_tab, { bang = true })
vim.api.nvim_create_user_command('DapCloseDebugTab', close_debug_tab, { bang = true })

-- Automatically open and close DAP UI
dap.listeners.after.event_initialized['dapui_config'] = function()
    open_debug_tab()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
    close_debug_tab()
end
dap.listeners.before.event_exited['dapui_config'] = function()
    close_debug_tab()
end

-- Setup virtual text
dap_virtual_text.setup {}

-----------------------------------------------------------
-- DAP signs
-----------------------------------------------------------

vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DiagnosticSignError' })
vim.fn.sign_define(
    'DapBreakpointCondition',
    { text = 'ﳁ', texthl = 'DiagnosticSignError' }
)
vim.fn.sign_define('DapLogPoint', { text = 'ﱴ', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define(
    'DapBreakpointRejected',
    { text = '', texthl = 'DiagnosticSignError' }
)
