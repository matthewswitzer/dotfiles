-----------------------------------------------------------
-- Devicons Configuration
-----------------------------------------------------------

local devicons = require 'nvim-web-devicons'

-----------------------------------------------------------
-- Setup
-----------------------------------------------------------

devicons.setup {}

-----------------------------------------------------------
-- Custom icons
-----------------------------------------------------------

devicons.set_icon {
    ['.editorconfig'] = {
        icon = '',
        color = '#ffffff',
        cterm_color = '15',
        name = 'EditorConfig',
    },
    ['.eslintrc.json'] = {
        icon = '',
        color = '#5f00ff',
        cterm_color = '57',
        name = 'eslint',
    },
}
