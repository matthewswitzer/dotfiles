-----------------------------------------------------------
-- Bufferline Configuration
-----------------------------------------------------------

require('bufferline').setup {
    options = {
        buffer_close_icon = '󰅖',
        close_command = 'Bdelete! %d',
        offsets = {
            {
                filetype = 'neo-tree',
                text = 'File Explorer',
                text_align = 'left',
                highlight = 'BufferLineOffset',
                padding = 1,
            },
        },
    },
}
