-----------------------------------------------------------
-- FTerm Configuration
-----------------------------------------------------------

local fterm = require 'FTerm'

-----------------------------------------------------------
-- Default Setup
-----------------------------------------------------------

local defaults = {
    border = 'rounded',
    dimensions = {
        height = 0.9,
        width = 0.9,
    },
}

fterm.setup(defaults)

-----------------------------------------------------------
-- Custom Terminals
-----------------------------------------------------------

local function terminal(opts)
    local options = defaults
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end

    return fterm:new(options)
end

local lazygit = terminal {
    ft = 'lazyterm',
    cmd = 'lazygit',
}

local lazydocker = terminal {
    ft = 'lazyterm',
    cmd = 'lazydocker',
}

-- Code Runner
local function run_code()
    local runners = {
        lua = 'lua',
        javascript = 'node',
        python = 'python',
    }
    local buf = vim.api.nvim_buf_get_name(0)
    local ftype = vim.filetype.match { filename = buf }
    local exec = runners[ftype]
    if exec ~= nil then
        fterm.scratch { cmd = { exec, buf } }
    end
end

-----------------------------------------------------------
-- User Commands
-----------------------------------------------------------

local command = vim.api.nvim_create_user_command

-- :FTerm{Open,Close,Exit,Toggle}
command('FTermOpen', fterm.open, { bang = true })
command('FTermClose', fterm.close, { bang = true })
command('FTermExit', fterm.exit, { bang = true })
command('FTermToggle', fterm.toggle, { bang = true })

-- :LazygitToggle
command('LazygitToggle', function()
    lazygit:toggle()
end, { bang = true })

-- :LazydockerToggle
command('LazydockerToggle', function()
    lazydocker:toggle()
end, { bang = true })

-- :FTermRunCode
command('FTermRunCode', function()
    run_code()
end, { bang = true })

-----------------------------------------------------------
-- Auto Commands
-----------------------------------------------------------

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Map `q` to quit and `<Esc>` to <Esc> on lazygit and lazydocker terminals
autocmd('TermOpen', {
    group = augroup('FTerm', { clear = true }),
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
