-----------------------------------------------------------
-- OneDark Configuration
-----------------------------------------------------------

require('onedark').setup {
    highlights = {
        ['@constructor'] = { fg = '$yellow', fmt = 'none' },
        ['@parameter'] = { fg = '$red', fmt = 'italic' },
        ['@parameter.reference'] = { fg = '$red', fmt = 'italic' },
        ['@variable'] = { fg = '$yellow', fmt = 'none' },
        ['@tag.attribute'] = { fg = '$orange', fmt = 'italic' },
        ['@tag.delimiter'] = { fg = '$fg' },
        FloatBorder = { fg = '$light_grey', bg = '$bg0' },
        NormalFloat = { fg = '$fg', bg = '$bg0' },
        BufferLineFill = { bg = '#1e2127' },
        BufferLineIndicatorSelected = { fg = '$grey' },
        BufferLineOffset = { fg = '$fg', bg = '$bg_d', fmt = 'bold,italic' },
        BufferLineSeparator = { fg = '#1e2127', bg = '#1e2127' },
        IndentBlankLineChar = { fg = '$bg3' },
        NeoTreeVertSplit = { fg = '$bg3', bg = '$bg_d' },
        NeoTreeWinSeparator = { fg = '$bg3', bg = '$bg_d' },
        TelescopePromptBorder = { fg = '$light_grey' },
        TelescopePreviewBorder = { fg = '$light_grey' },
        TelescopeResultsBorder = { fg = '$light_grey' },
    },
    diagnostics = {
        darker = false,
    },
}
require('onedark').load()
