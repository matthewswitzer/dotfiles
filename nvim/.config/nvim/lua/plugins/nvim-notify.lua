-----------------------------------------------------------
-- Notify Configuration
-----------------------------------------------------------

local notify = require 'notify'

-----------------------------------------------------------
-- Notification setup
-----------------------------------------------------------

notify.setup {
    top_down = false,
}

-- Set as default vim.notify function
vim.notify = notify
