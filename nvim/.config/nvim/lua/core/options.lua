-----------------------------------------------------------
-- Neovim Configuration Options
-----------------------------------------------------------

local g = vim.g
local opt = vim.opt
local api = vim.api

-----------------------------------------------------------
-- General
-----------------------------------------------------------
opt.cmdheight = 0 -- collapse the command-line
opt.completeopt = 'menu,menuone,noselect' -- autocompletion options
opt.cursorline = true -- highlight current line
opt.fillchars:append 'vert:▕' -- character to use for vertical splits
opt.fillchars:append 'vertright:▕' -- vertical/horizontal split intersection character
opt.hidden = true -- hide buffers instead of closing them
opt.laststatus = 3 -- enable global statusline
opt.lazyredraw = true -- redraw screen only when we need to
opt.mouse = 'a' -- enable mouse support
opt.number = false -- don't show line numbers
opt.pumblend = 3 -- add transparency to popup menus
opt.pumheight = 10 -- show up to 10 items in the popup menu
opt.scrolloff = 2 -- number of lines to keep above and below the cursor
opt.signcolumn = 'yes' -- always show signcolumn
opt.showmode = false -- let lualine handle showing modes
opt.splitbelow = true -- split horizontally to the bottom
opt.splitright = true -- split vertically to the right
opt.termguicolors = true -- enable truecolor mode
opt.timeoutlen = 500 -- wait 500ms for mapping sequences to complete
opt.updatetime = 150 -- wait 150ms after typing to update
opt.visualbell = true -- blink cursor on error instead of beeping
opt.whichwrap:append '<,>,h,l' -- automatically wrap left and right
opt.winblend = 3 -- add transparency to floating windows
opt.wrap = true -- wrap lines

-----------------------------------------------------------
-- Indentation
-----------------------------------------------------------
opt.expandtab = true -- convert <TAB> key-presses to spaces
opt.shiftwidth = 4 -- number of spaces to use for each step of (auto)indent
opt.softtabstop = 4 -- backspace after pressing <TAB> will remove up to this many spaces
opt.tabstop = 4 -- width that a <TAB> character displays as

-----------------------------------------------------------
-- Search
-----------------------------------------------------------
opt.hlsearch = true -- highlight matches
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- only ignore case if pattern is all lowercase

-----------------------------------------------------------
-- Backup
-----------------------------------------------------------
opt.backup = false -- don't keep backups
opt.swapfile = false -- don't create swap files
opt.writebackup = false -- don't create backup files

-----------------------------------------------------------
-- Undo
-----------------------------------------------------------
opt.undofile = true -- persist undo history between sessions

-- disable persistent undo for temp files
api.nvim_create_augroup('DisableUndo', { clear = true })
api.nvim_create_autocmd('BufWritePre', {
    group = 'DisableUndo',
    pattern = '/tmp/*',
    command = 'setlocal noundofile',
})

-----------------------------------------------------------
-- Providers
-----------------------------------------------------------
if vim.fn.has 'macunix' == 1 then
    g.python3_host_prog = '/opt/homebrew/bin/python3'
else
    g.python3_host_prog = '/usr/bin/python3'
end
g.loaded_python_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
