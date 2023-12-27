-----------------------------------------------------------
-- Colorscheme Configuration
-----------------------------------------------------------

return {

    -- onedark
    {
        'navarasu/onedark.nvim',
        lazy = false,
        priority = 1000,
        opts = {
            highlights = {
                ['@constructor'] = { fg = '$yellow', fmt = 'none' },
                ['@interface'] = { fg = '$yellow', fmt = 'none' },
                ['@parameter'] = { fg = '$red', fmt = 'italic' },
                ['@parameter.reference'] = { fg = '$red', fmt = 'italic' },
                ['@punctuation.special'] = { fg = '$cyan' },
                ['@tag.attribute'] = { fg = '$orange', fmt = 'italic' },
                ['@tag.delimiter'] = { fg = '$fg' },
                ['@variable'] = { fg = '$yellow', fmt = 'none' },
                ['@lsp.type.variable'] = { fg = '$yellow', fmt = 'none' },
                FloatBorder = { fg = '$light_grey', bg = '$bg0' },
                NormalFloat = { fg = '$fg', bg = '$bg0' },
                BufferLineFill = { bg = '#1e2127' },
                BufferLineIndicatorSelected = { fg = '$grey' },
                BufferLineOffset = { fg = '$fg', bg = '$bg_d', fmt = 'bold' },
                BufferLineSeparator = { fg = '#1e2127', bg = '#1e2127' },
                IblIndent = { fg = '$bg3' },
                NeoTreeVertSplit = { fg = '$bg3', bg = '$bg_d' },
                NeoTreeWinSeparator = { fg = '$bg3', bg = '$bg_d' },
                TelescopePromptBorder = { fg = '$light_grey' },
                TelescopePreviewBorder = { fg = '$light_grey' },
                TelescopeResultsBorder = { fg = '$light_grey' },
            },
            diagnostics = {
                darker = false,
            },
        },
        config = function(_, opts)
            require('onedark').setup(opts)
            require('onedark').load()
        end,
    },
}
