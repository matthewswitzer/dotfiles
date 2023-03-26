-----------------------------------------------------------
-- Telescope Configuration
-----------------------------------------------------------

require('telescope').setup {
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
            results = { '─', '│', '─', '│', '├', '┤', '╯', '╰' },
            preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        },
        mappings = {
            i = {
                ['<ESC>'] = require('telescope.actions').close,
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

-- Load extensions
require('telescope').load_extension 'fzf'
require('telescope').load_extension 'tasks'
require('telescope').load_extension 'neoclip'
