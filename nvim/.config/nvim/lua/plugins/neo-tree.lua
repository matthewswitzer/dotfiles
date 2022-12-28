-----------------------------------------------------------
-- Neo-tree Configuration
-----------------------------------------------------------

-- Remove deprecated commands from v1.x
vim.g.neo_tree_remove_legacy_commands = 1

require('neo-tree').setup {
    default_component_configs = {
        modified = {
            symbol = '',
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
}
