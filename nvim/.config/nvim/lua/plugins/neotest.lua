-----------------------------------------------------------
-- Neotest Configuration
-----------------------------------------------------------

require('neotest').setup {
    adapters = {
        require 'neotest-jest' { jestCommand = 'npm test --' },
        require 'neotest-python' { dap = { justMyCode = false } },
    },
    diagnostic = {
        enabled = false,
    },
    icons = {
        failed = '󱎘',
        passed = '󰸞',
        running = '󰓦',
        skipped = '󱘹',
        unknown = '󰝦',
    },
}
