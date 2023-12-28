-----------------------------------------------------------
-- Editor Configuration
-----------------------------------------------------------

return {

    -- fuzzy finder
    {
        'nvim-telescope/telescope.nvim',
        cmd = 'Telescope',
        dependencies = {
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                enabled = vim.fn.executable 'make' == 1,
            },
            {
                'nvim-telescope/telescope-live-grep-args.nvim',
                version = '^1.0.0',
            },
        },
        keys = {
            -- Show keymaps with <Leader>K
            { '<Leader>K', '<Cmd>Telescope keymaps<CR>', desc = 'Show Keymaps' },

            -- Find files in the current directory with <Leader>p
            { '<Leader>p', '<Cmd>Telescope find_files<CR>', desc = 'Find Files' },

            -- Search the current buffer with <Leader>fb
            {
                '<Leader>fb',
                '<Cmd>Telescope current_buffer_fuzzy_find<CR>',
                desc = 'Search Current Buffer',
            },

            -- Search the current directory with <Leader>fd
            {
                '<Leader>fd',
                '<Cmd>Telescope live_grep<CR>',
                desc = 'Search Current Directory',
            },

            -- Search with custom grep args using <Leader>fa
            {
                '<Leader>fa',
                ':lua require("telescope").extensions.live_grep_args.live_grep_args()<CR>',
                desc = 'Search Using Grep Args',
            },

            -- Search highlight groups with <Leader>fh
            {
                '<Leader>fh',
                '<Cmd>Telescope highlights<CR>',
                desc = 'Search Highlight Groups',
            },

            -- Show treesitter symbols with <Leader>s
            { '<Leader>s', '<Cmd>Telescope treesitter<CR>', desc = 'Find Symbols' },

            -- Show workspace diagnostics with <Leader>g
            {
                '<Leader>g',
                '<Cmd>Telescope diagnostics<CR>',
                desc = 'Show Workspace Diagnostics',
            },
        },
        opts = function()
            local actions = require 'telescope.actions'

            return {
                defaults = {
                    results_title = false,
                    sorting_strategy = 'ascending',
                    layout_strategy = 'center',
                    layout_config = {
                        preview_cutoff = 1,
                        width = function(_, max_columns, _)
                            return math.min(max_columns, 80)
                        end,
                        height = function(_, _, max_lines)
                            return math.min(max_lines, 15)
                        end,
                    },
                    border = true,
                    borderchars = {
                        prompt = { '─', '│', ' ', '│', '╭', '╮', '│', '│' },
                        results = {
                            '─',
                            '│',
                            '─',
                            '│',
                            '├',
                            '┤',
                            '╯',
                            '╰',
                        },
                        preview = {
                            '─',
                            '│',
                            '─',
                            '│',
                            '╭',
                            '╮',
                            '╯',
                            '╰',
                        },
                    },
                    winblend = vim.o.winblend,
                    mappings = {
                        i = {
                            ['<ESC>'] = actions.close,
                        },
                    },
                    vimgrep_arguments = {
                        'rg',
                        '--color=never',
                        '--no-heading',
                        '--with-filename',
                        '--line-number',
                        '--column',
                        '--smart-case',
                        '--ignore',
                        '--hidden',
                    },
                },
                pickers = {
                    find_files = {
                        follow = true,
                        hidden = true,
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = 'smart_case',
                    },
                },
            }
        end,
        config = function(_, opts)
            require('telescope').setup(opts)

            require('telescope').load_extension 'fzf'
            require('telescope').load_extension 'live_grep_args'
        end,
    },

    -- clipboard management
    {
        'AckslD/nvim-neoclip.lua',
        keys = {
            -- Show clipboard entries with <Leader>y
            {
                '<Leader>y',
                '<Cmd>Telescope neoclip<CR>',
                desc = 'Show Clipboard Entries',
            },
        },
    },

    -- git status
    {
        'lewis6991/gitsigns.nvim',
        event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
        keys = {
            -- Toggle current line blame with <Leader>B
            {
                '<Leader>B',
                '<Cmd>Gitsigns toggle_current_line_blame<CR>',
                desc = 'Toggle Current Line Blame',
            },
        },
        opts = {
            signs = {
                add = { text = '▎' },
                change = { text = '▎' },
                delete = { text = '▁' },
                topdelete = { text = '▔' },
                changedelete = { text = '▎' },
                untracked = { text = '▎' },
            },
        },
    },

    -- indentation guides
    {
        'lukas-reineke/indent-blankline.nvim',
        event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
        main = 'ibl',
        opts = {
            indent = {
                char = '│',
                tab_char = '│',
            },
            scope = {
                show_start = false,
                show_end = false,
            },
        },
    },

    -- jump to location
    {
        'smoka7/hop.nvim',
        version = '*',
        keys = {
            -- Easymotion-like mappings
            { '<Leader><Leader>s', '<Cmd>HopChar1<CR>', desc = 'Hop by 1 Char' },
            {
                '<Leader><Leader>f',
                '<Cmd>HopChar1AC<CR>',
                desc = 'Hop by 1 Char Forward',
            },
            {
                '<Leader><Leader>F',
                '<Cmd>HopChar1BC<CR>',
                desc = 'Hop by 1 Char Backward',
            },
            {
                '<Leader><Leader>/',
                '<Cmd>HopPattern<CR>',
                desc = 'Hop by Search Pattern',
            },
            { '<Leader><Leader>j', '<Cmd>HopLineAC<CR>', desc = 'Hop by Lines Down' },
            { '<Leader><Leader>k', '<Cmd>HopLineBC<CR>', desc = 'Hop by Lines Up' },
            { '<Leader><Leader>w', '<Cmd>HopWordAC<CR>', desc = 'Hop by Words Forward' },
            { '<Leader><Leader>b', '<Cmd>HopWordBC<CR>', desc = 'Hop by Words Backward' },
        },
        opts = {},
    },

    -- commenting
    {
        'numToStr/Comment.nvim',
        event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
        opts = {},
    },

    -- autopairs
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        opts = {},
    },

    -- surround selections
    {
        'kylechui/nvim-surround',
        version = '*',
        event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
        opts = {},
    },

    -- test runner
    {
        'nvim-neotest/neotest',
        dependencies = {
            'plenary.nvim',
            'nvim-treesitter',
            'antoinemadec/FixCursorHold.nvim',
            'haydenmeade/neotest-jest',
            'nvim-neotest/neotest-python',
        },
        keys = {
            -- Toggle test summary window with <Leader>nt
            {
                '<Leader>nt',
                '<Cmd>lua require("neotest").summary.toggle()<CR>',
                desc = 'Toggle Test Summary',
            },

            -- Run the nearest test with <Leader>nr
            {
                '<Leader>nr',
                '<Cmd>lua require("neotest").run.run()<CR>',
                desc = 'Run Test',
            },

            -- Run all tests in the current file with <Leader>nR
            {
                '<Leader>nR',
                '<Cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>',
                desc = 'Run All Tests',
            },

            -- Debug the nearest test with <Leader>nd
            {
                '<Leader>nd',
                '<Cmd>lua require("neotest").run.run({ strategy = "dap" })<CR>',
                desc = 'Debug Test',
            },

            -- Stop the nearest test with <Leader>ns
            {
                '<Leader>ns',
                '<Cmd>lua require("neotest").run.stop()<CR>',
                desc = 'Stop Test',
            },

            -- Display test result output with <Leader>no
            {
                '<Leader>no',
                '<Cmd>lua require("neotest").output.open({ short = true })<CR>',
                desc = 'Display Test Results',
            },
        },
        opts = function()
            local jest = require 'neotest-jest'
            local python = require 'neotest-python'

            return {
                adapters = {
                    jest { jestCommand = 'npm test --' },
                    python { dap = { justMyCode = false } },
                },
                diagnostic = {
                    enabled = false,
                },
                icons = {
                    failed = '󱎘',
                    passed = '󰸞',
                    running = '󰓦',
                    skipped = '󱘹',
                    unknown = '󰝦',
                },
            }
        end,
    },

    -- http client
    {
        'rest-nvim/rest.nvim',
        version = 'v1.x.x',
        ft = 'http',
        dependencies = {
            'plenary.nvim',
        },
        keys = {
            -- Run the HTTP request under the cursor with <Leader>//
            { '<Leader>//', '<Plug>RestNvim', desc = 'Run HTTP Request' },

            -- Preview the cURL command with <Leader>/?
            { '<Leader>/?', '<Plug>RestNvimPreview', desc = 'Preview cURL Command' },

            -- Re-run the last HTTP request with <Leader>?
            { '<Leader>?', '<Plug>RestNvimLast', desc = 'Re-run HTTP Request' },
        },
        opts = {
            result = {
                formatters = {
                    json = function(body)
                        return vim.fn.system({ 'prettierd', '.json' }, body)
                    end,
                    html = function(body)
                        return vim.fn.system({ 'prettierd', '.html' }, body)
                    end,
                },
            },
        },
    },
}
