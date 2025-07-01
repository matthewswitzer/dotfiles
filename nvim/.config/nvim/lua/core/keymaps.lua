-----------------------------------------------------------
-- Keymap Configuration
-----------------------------------------------------------

local g = vim.g

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

-- Navigate splits in normal with <Leader>{h,j,k,l}
map('n', '<Leader>h', '<C-w>h', { desc = 'Navigate to Left Window' })
map('n', '<Leader>j', '<C-w>j', { desc = 'Navigate to Bottom Window' })
map('n', '<Leader>k', '<C-w>k', { desc = 'Navigate to Top Window' })
map('n', '<Leader>l', '<C-w>l', { desc = 'Navigate to Right Window' })

-- Navigate splits in terminal with <C-{h,j,k,l}>
map('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Navigate to Left Window' })
map('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = 'Navigate to Bottom Window' })
map('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = 'Navigate to Top Window' })
map('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = 'Navigate to Right Window' })

-- Resize split height with <Leader>{-,=}
map('n', '<Leader>-', '5<C-w>-', { desc = 'Decrease Split Height' })
map('n', '<Leader>=', '5<C-w>+', { desc = 'Increase Split Height' })

-- Resize split width with <Leader>{_,+}
map('n', '<Leader>_', '5<C-w>>', { desc = 'Decrease Split Width' })
map('n', '<Leader>+', '5<C-w><', { desc = 'Increase Split Width' })

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
-- Plugin Shortcuts
-----------------------------------------------------------

-- Inspect highlight group under cursor with <Leader>H
map('n', '<Leader>H', '<Cmd>Inspect<CR>', { desc = 'Show Highlight Group Under Cursor' })

-- Show Lazy UI with <Leader>L
map('n', '<Leader>L', '<Cmd>Lazy<CR>', { desc = 'Show Lazy' })
