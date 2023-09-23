-----------------------------------------------------------
-- Keymap Configuration
-----------------------------------------------------------

local g = vim.g
local api = vim.api

local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-----------------------------------------------------------
-- Neovim Shortcuts
-----------------------------------------------------------

-- Change leader to <Space>
map('n', '<Space>', '<Nop>', { desc = 'Leader' })
g.mapleader = ' '

-- Clear search highlighting with <CR>
map('n', '<CR>', ':nohl<CR><CR>', { desc = 'Clear Search Highlights' })

-- Move vertically by visual line (don't skip wrapped lines)
map('n', 'j', 'gj', { noremap = false, desc = 'Move Down' })
map('n', 'k', 'gk', { noremap = false, desc = 'Move Up' })

-- Navigate splits with <Leader>{h,j,k,l}
map('n', '<Leader>h', '<C-w>h', { desc = 'Navigate to Left Window' })
map('n', '<Leader>j', '<C-w>j', { desc = 'Navigate to Bottom Window' })
map('n', '<Leader>k', '<C-w>k', { desc = 'Navigate to Top Window' })
map('n', '<Leader>l', '<C-w>l', { desc = 'Navigate to Right Window' })

-- Close windows with q
map('n', 'q', '<Cmd>close<CR>', { desc = 'Close Window' })

-- Re-enter visual mode when indenting
map('v', '>', '>gv', { desc = 'Increase Indent' })
map('v', '<', '<gv', { desc = 'Decrease Indent' })

-- Select all lines with <Leader>a
map('n', '<Leader>a', 'ggVG', { desc = 'Select All' })

-- Swap lines with ]e and [e
map('n', ']e', 'ddp', { desc = 'Swap Line with Next' })
map('n', '[e', 'ddkP', { desc = 'Swap Line with Previous' })

-- Add lines above or below with ]<Space> and [<Space>
map('n', ']<Space>', 'o<Esc>k', { desc = 'Add Line Below' })
map('n', '[<Space>', 'O<Esc>j', { desc = 'Add Line Above' })

-- Show and hide line numbers with ]n and [n
map('n', ']n', ':setlocal number<CR>', { desc = 'Show Line Numbers' })
map('n', '[n', ':setlocal nonumber<CR>', { desc = 'Hide Line Numbers' })

-- Save files with <C-s>
map('n', '<C-s>', ':update<CR>', { desc = 'Save File' })
map('v', '<C-s>', '<Esc>:update<CR>', { desc = 'Save File' })
map('i', '<C-s>', '<Esc>:update<CR>', { desc = 'Save File ' })

-- Source the current file with <Leader>S
map('n', '<Leader>S', ':so %<CR>', { desc = 'Source Current File' })

-- Quit with <Leader>q; force quit with <Leader>Q
map('n', '<Leader>q', ':qa<CR>', { desc = 'Quit' })
map('n', '<Leader>Q', ':qa!<CR>', { desc = 'Force Quit' })

-----------------------------------------------------------
-- Bufferline
-----------------------------------------------------------

-- Cycle through buffers with ]b and [b
map('n', ']b', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Go to Next Buffer' })
map('n', '[b', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Go to Prev Buffer' })

-- Pick buffers with <Leader><Leader>p; pick close with <Leader><Leader>P
map('n', '<Leader><Leader>p', '<Cmd>BufferLinePick<CR>', { desc = 'Pick Buffer to Open' })
map(
    'n',
    '<Leader><Leader>P',
    '<Cmd>BufferLinePickClose<CR>',
    { desc = 'Pick Buffer to Close' }
)

-- Reorder buffers using <Leader>b{h,l}
map('n', '<Leader>bh', '<Cmd>BufferLineMovePrev<CR>', { desc = 'Reorder Buffer Left' })
map('n', '<Leader>bl', '<Cmd>BufferLineMoveNext<CR>', { desc = 'Reorder Buffer Right' })

-----------------------------------------------------------
-- Bufdelete
-----------------------------------------------------------

-- Close current buffer with <Leader>w
map('n', '<Leader>w', '<Cmd>Bdelete!<CR>', { desc = 'Close Current Buffer' })

-- Close all but current buffer with <Leader>W
local function close_all_but_current_buf()
    local current = api.nvim_get_current_buf()
    local buffers = require('bufferline.utils').get_valid_buffers()

    for _, bufnr in pairs(buffers) do
        if bufnr ~= current then
            vim.cmd('Bdelete! ' .. bufnr)
        end
    end
end
map(
    'n',
    '<Leader>W',
    close_all_but_current_buf,
    { desc = 'Close All But Current Buffer' }
)

-----------------------------------------------------------
-- Neo Tree
-----------------------------------------------------------

-- Toggle the file explorer with <Leader>e; focus with <Leader>E
map('n', '<Leader>e', '<Cmd>Neotree toggle<CR>', { desc = 'Toggle Neotree' })
map('n', '<Leader>E', '<Cmd>Neotree focus<CR>', { desc = 'Focus Neotree' })

-----------------------------------------------------------
-- FTerm
-----------------------------------------------------------

-- Toggle the terminal with <C-t>
map('n', '<C-t>', '<Cmd>FTermToggle<CR>', { desc = 'Toggle Terminal' })
map('t', '<C-t>', '<C-\\><C-n><Cmd>FTermToggle<CR>', { desc = 'Toggle Terminal' })

-- Close the terminal with <Esc>
map('t', '<Esc>', '<Cmd>FTermClose<CR>', { desc = 'Close Terminal' })

-- Toggle lazygit with <Leader>G
map('n', '<Leader>G', '<Cmd>LazygitToggle<CR>', { desc = 'Toggle Lazygit' })

-- Toggle lazydocker with <Leader>C
map('n', '<Leader>C', '<Cmd>LazydockerToggle<CR>', { desc = 'Toggle Lazydocker' })

-- Run code in current buffer with <Leader><Enter>
map(
    'n',
    '<Leader><Enter>',
    '<Cmd>FTermRunCode<CR>',
    { desc = 'Run Code in Current Buffer' }
)

-----------------------------------------------------------
-- Telescope
-----------------------------------------------------------

-- Show keymaps with <Leader>K
map('n', '<Leader>K', '<Cmd>Telescope keymaps<CR>', { desc = 'Show Keymaps' })

-- Find files in the current directory with <Leader>p
map('n', '<Leader>p', '<Cmd>Telescope find_files<CR>', { desc = 'Find Files' })

-- Search the current buffer with <Leader>fb
map(
    'n',
    '<Leader>fb',
    '<Cmd>Telescope current_buffer_fuzzy_find<CR>',
    { desc = 'Search Current Buffer' }
)

-- Search the current directory with <Leader>fd
map(
    'n',
    '<Leader>fd',
    '<Cmd>Telescope live_grep<CR>',
    { desc = 'Search Current Directory' }
)

-- Search with custom grep args using <Leader>fa
map(
    'n',
    '<Leader>fa',
    ':lua require("telescope").extensions.live_grep_args.live_grep_args()<CR>',
    { desc = 'Search Using Grep Args' }
)

-- Search highlight groups with <Leader>fh
map(
    'n',
    '<Leader>fh',
    '<Cmd>Telescope highlights<CR>',
    { desc = 'Search Highlight Groups' }
)

-- Inspect highlight group under cursor with <Leader>H
map('n', '<Leader>H', '<Cmd>Inspect<CR>', { desc = 'Show Highlight Group Under Cursor' })

-- Show treesitter symbols with <Leader>s
map('n', '<Leader>s', '<Cmd>Telescope treesitter<CR>', { desc = 'Find Symbols' })

-- Show workspace diagnostics with <Leader>g
map(
    'n',
    '<Leader>g',
    '<Cmd>Telescope diagnostics<CR>',
    { desc = 'Show Workspace Diagnostics' }
)

-- Show clipboard entries with <Leader>y
map('n', '<Leader>y', '<Cmd>Telescope neoclip<CR>', { desc = 'Show Clipboard Entries' })

-----------------------------------------------------------
-- Notify
-----------------------------------------------------------

-- Show notifications history with <Leader>N
map('n', '<Leader>N', '<Cmd>Telescope notify<CR>', { desc = 'Show Notifications' })

-- Dismiss all notifications with Q
map('n', 'Q', ':lua require("notify").dismiss()<CR>', { desc = 'Dismiss Notifications' })

-----------------------------------------------------------
-- Hop
-----------------------------------------------------------

-- Easymotion-like mappings
map('n', '<Leader><Leader>s', '<Cmd>HopChar1<CR>', { desc = 'Hop by 1 Char' })
map('n', '<Leader><Leader>f', '<Cmd>HopChar1AC<CR>', { desc = 'Hop by 1 Char Forward' })
map('n', '<Leader><Leader>F', '<Cmd>HopChar1BC<CR>', { desc = 'Hop by 1 Char Backward' })
map('n', '<Leader><Leader>/', '<Cmd>HopPattern<CR>', { desc = 'Hop by Search Pattern' })
map('n', '<Leader><Leader>j', '<Cmd>HopLineAC<CR>', { desc = 'Hop by Lines Down' })
map('n', '<Leader><Leader>k', '<Cmd>HopLineBC<CR>', { desc = 'Hop by Lines Up' })
map('n', '<Leader><Leader>w', '<Cmd>HopWordAC<CR>', { desc = 'Hop by Words Forward' })
map('n', '<Leader><Leader>b', '<Cmd>HopWordBC<CR>', { desc = 'Hop by Words Backward' })

-----------------------------------------------------------
-- Gitsigns
-----------------------------------------------------------

-- Toggle current line blame with <Leader>B
map(
    'n',
    '<Leader>B',
    '<Cmd>Gitsigns toggle_current_line_blame<CR>',
    { desc = 'Toggle Current Line Blame' }
)

-----------------------------------------------------------
-- Glow
-----------------------------------------------------------

-- Preview markdown in the current buffer with <Leader>md
map('n', '<Leader>md', '<Cmd>Glow<CR>', { desc = 'Preview Markdown' })

-----------------------------------------------------------
-- Tasks
-----------------------------------------------------------

-- Show available task to run with <Leader>t
map('n', '<Leader>t', '<Cmd>OverseerRun<CR>', { desc = 'Show Tasks' })

-- Show running tasks with <Leader>T
map('n', '<Leader>T', '<Cmd>OverseerToggle<CR>', { desc = 'Show Running Tasks' })

-----------------------------------------------------------
-- Mason
-----------------------------------------------------------

-- Open Mason with <Leader>M
map('n', '<Leader>M', '<Cmd>Mason<CR>', { desc = 'Open Mason' })

-----------------------------------------------------------
-- DAP
-----------------------------------------------------------

-- Debugger commands
map(
    'n',
    '<Leader>dj',
    "<Cmd>lua require('dap').continue()<CR>",
    { desc = 'Start/Continue Debugging' }
)
map('n', '<Leader>dk', "<Cmd>lua require('dap').step_over()<CR>", { desc = 'Step Over' })
map('n', '<Leader>dl', "<Cmd>lua require('dap').step_into()<CR>", { desc = 'Step Into' })
map('n', '<Leader>dh', "<Cmd>lua require('dap').step_out()<CR>", { desc = 'Step Out' })
map(
    'n',
    '<Leader>dp',
    "<Cmd>lua require('dap').toggle_breakpoint()<CR>",
    { desc = 'Toggle Breakpoint' }
)
map(
    'n',
    '<Leader>dP',
    "<Cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
    { desc = 'Set Breakpoint Condition' }
)
map(
    'n',
    '<Leader>dL',
    "<Cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
    { desc = 'Set Log Point Message' }
)
map(
    'n',
    '<Leader>dd',
    "<Cmd>lua require('dap').clear_breakpoints()<CR>",
    { desc = 'Clear Breakpoints' }
)
map(
    'n',
    '<Leader>dr',
    "<Cmd>lua require('dap').repl.toggle()<CR>",
    { desc = 'Toggle DAP REPL' }
)
map('n', '<Leader>dt', '<Cmd>DapOpenDebugTab<CR>', { desc = 'Open Debug Tab' })
map('n', '<Leader>dT', '<Cmd>DapCloseDebugTab<CR>', { desc = 'Close Debug Tab' })
map(
    'n',
    '<Leader>dJ',
    "<Cmd>lua require('dap').run_last()<CR>",
    { desc = 'Run Last Debug Adapter' }
)
map(
    'n',
    '<Leader>dc',
    "<Cmd>lua require('dap').terminate()<CR>",
    { desc = 'Terminate Debug Session' }
)
map('n', '<Leader>dv', '<Cmd>DapLoadLaunchJson<CR>', { desc = 'Load launch.json' })

-----------------------------------------------------------
-- Neotest
-----------------------------------------------------------

-- Toggle test summary window with <Leader>nt
map(
    'n',
    '<Leader>nt',
    '<Cmd>lua require("neotest").summary.toggle()<CR>',
    { desc = 'Toggle Test Summary' }
)

-- Run the nearest test with <Leader>nr
map('n', '<Leader>nr', '<Cmd>lua require("neotest").run.run()<CR>', { desc = 'Run Test' })

-- Run all tests in the current file with <Leader>nR
map(
    'n',
    '<Leader>nR',
    '<Cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>',
    { desc = 'Run All Tests' }
)

-- Debug the nearest test with <Leader>nd
map(
    'n',
    '<Leader>nd',
    '<Cmd>lua require("neotest").run.run({ strategy = "dap" })<CR>',
    { desc = 'Debug Test' }
)

-- Stop the nearest test with <Leader>ns
map(
    'n',
    '<Leader>ns',
    '<Cmd>lua require("neotest").run.stop()<CR>',
    { desc = 'Stop Test' }
)

-- Display test result output with <Leader>no
map(
    'n',
    '<Leader>no',
    '<Cmd>lua require("neotest").output.open({ short = true })<CR>',
    { desc = 'Display Test Results' }
)

-----------------------------------------------------------
-----------------------------------------------------------
