-----------------------------------------------------------
-- Notify Configuration
-----------------------------------------------------------

local notify = require 'notify'

-----------------------------------------------------------
-- Notification setup
-----------------------------------------------------------

notify.setup {
    fps = 60,
    timeout = 3000,
    top_down = false,
}

-- Set as default vim.notify function
vim.notify = notify
