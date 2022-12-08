-----------------------------------------------------------
-- Tasks Configuration
-----------------------------------------------------------

require('tasks').setup {
    sources = {
        npm = require 'tasks.sources.npm',
        vscode = require 'tasks.sources.tasksjson',
    },
}
