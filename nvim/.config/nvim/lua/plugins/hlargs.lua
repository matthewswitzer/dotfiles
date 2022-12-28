-----------------------------------------------------------
-- hlargs Configuration
-----------------------------------------------------------

require('hlargs').setup {
    highlight = { fg = '#e86671', italic = true },
    disable = function(lang, _)
        -- whitelist for filetypes hlargs will handle
        local included_filetypes = {
            'python',
        }
        return not vim.tbl_contains(included_filetypes, lang)
    end,
}
