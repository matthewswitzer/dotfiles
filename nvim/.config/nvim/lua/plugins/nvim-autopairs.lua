-----------------------------------------------------------
-- Autopairs Configuration
-----------------------------------------------------------

require('nvim-autopairs').setup {
    check_ts = true,
    ts_config = {
        lua = { 'string' },
        javascript = { 'template_string' },
    },
}
