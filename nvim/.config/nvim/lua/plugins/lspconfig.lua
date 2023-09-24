-----------------------------------------------------------
-- LSP Configuration
-----------------------------------------------------------

local mason = require 'mason'
local mason_lspconfig = require 'mason-lspconfig'
local mason_tool_installer = require 'mason-tool-installer'
local lspconfig = require 'lspconfig'

-----------------------------------------------------------
-- Mason setup
-----------------------------------------------------------
mason.setup {
    ui = {
        icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
        },
    },
}

mason_tool_installer.setup {
    ensure_installed = {
        -- LSP
        'bash-language-server',
        'css-lsp',
        'dockerfile-language-server',
        'efm',
        'emmet-ls',
        'eslint-lsp',
        'html-lsp',
        'json-lsp',
        'lua-language-server',
        'pyright',
        'stylelint-lsp',
        'typescript-language-server',
        'yaml-language-server',

        -- DAP
        'debugpy',

        -- Linter
        'flake8',
        'markdownlint',

        -- Formatter
        'black',
        'isort',
        'prettierd',
        'stylua',
    },
    auto_update = true,
}

-----------------------------------------------------------
-- efm-ls setup
-----------------------------------------------------------

-- linters
local flake8 = require 'efmls-configs.linters.flake8'
local markdownlint = require 'efmls-configs.linters.markdownlint'

-- formatters
local black = require 'efmls-configs.formatters.black'
local isort = require 'efmls-configs.formatters.isort'
local prettierd = require 'efmls-configs.formatters.prettier_d'
local stylua = require 'efmls-configs.formatters.stylua'

-- default config file for prettier
prettierd = vim.tbl_extend('force', prettierd, {
    rootMarkers = {},
    env = {
        string.format(
            'PRETTIERD_DEFAULT_CONFIG=%s',
            vim.fn.expand '~/.config/nvim/utils/config/.prettierrc.json'
        ),
    },
})

-- extra args for isort
isort = vim.tbl_extend('force', isort, {
    arguments = {
        '--profile',
        'black',
    },
})

local efmlangs = {
    html = {
        prettierd,
    },
    javascript = {
        prettierd,
    },
    javascriptreact = {
        prettierd,
    },
    json = {
        prettierd,
    },
    jsonc = {
        prettierd,
    },
    lua = {
        stylua,
    },
    markdown = {
        markdownlint,
    },
    python = {
        flake8,
        black,
        isort,
    },
    typescript = {
        prettierd,
    },
    typescriptreact = {
        prettierd,
    },
}

local efmls = {
    filetypes = vim.tbl_keys(efmlangs),
    settings = {
        rootMarkers = { '.git/' },
        languages = efmlangs,
    },
    init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
    },
}

-----------------------------------------------------------
-- Language server configuration
-----------------------------------------------------------

-- Use efm-ls configured formatting
local lsp_formatter = function(bufnr)
    vim.lsp.buf.format {
        filter = function(client)
            return client.name == 'efm'
        end,
        bufnr = bufnr,
    }
end

local organize_imports = function(client, bufnr)
    local sort_commands = {
        tsserver = '_typescript.organizeImports',
    }
    local command = sort_commands[client.name]

    if command == nil then
        return
    end

    vim.lsp.buf.execute_command {
        command = command,
        arguments = { vim.api.nvim_buf_get_name(bufnr) },
    }
end

local format_group = vim.api.nvim_create_augroup('LspFormatting', {})

-- Only setup the following buffer options when an lsp is attached
local on_attach = function(client, bufnr)
    -- format on save
    vim.api.nvim_clear_autocmds { group = format_group, buffer = bufnr }
    vim.api.nvim_create_autocmd('BufWritePre', {
        group = format_group,
        buffer = bufnr,
        callback = function()
            lsp_formatter(bufnr)

            -- formatting makes codelenses disappear, so refresh afterwards
            if client.server_capabilities.codeLensProvider then
                vim.lsp.codelens.refresh()
            end
        end,
    })

    -- show diagnostics on cursor hold
    vim.api.nvim_create_autocmd('CursorHold', {
        buffer = bufnr,
        callback = function()
            local float_opts = {
                focusable = false,
                close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
                prefix = '',
                scope = 'cursor',
            }
            vim.diagnostic.open_float(nil, float_opts)
        end,
    })

    -- automatically show and refresh codelens
    if client.server_capabilities.codeLensProvider then
        -- wait for the provider to be ready before the initial refresh
        vim.wait(100, function()
            vim.lsp.codelens.refresh()
        end)

        -- automatically refresh again on these events
        vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave' }, {
            buffer = bufnr,
            callback = vim.lsp.codelens.refresh,
        })
    end

    -- mappings
    local opts = { noremap = true, silent = true, buffer = bufnr }
    local map = vim.keymap.set
    map('n', 'K', vim.lsp.buf.hover, opts)
    map('n', 'gD', vim.lsp.buf.declaration, opts)
    map('n', 'gd', '<Cmd>Telescope lsp_definitions<CR>', opts)
    map('n', 'gi', '<Cmd>Telescope lsp_implementations<CR>', opts)
    map('n', 'gr', '<Cmd>Telescope lsp_references<CR>', opts)
    map('n', '<Leader>D', '<Cmd>Telescope lsp_type_definitions<CR>', opts)
    map('n', '<Leader>rn', vim.lsp.buf.rename, opts)
    map('n', '<Leader>.', vim.lsp.buf.code_action, opts)
    map('n', '<Leader>,', vim.lsp.codelens.run, opts)
    map('n', ']g', function()
        vim.diagnostic.goto_next { float = false }
    end, opts)
    map('n', '[g', function()
        vim.diagnostic.goto_prev { float = false }
    end, opts)
    map('n', '<C-f>', function()
        lsp_formatter(bufnr)
    end, opts)
    map('n', '<C-o>', function()
        organize_imports(client, bufnr)
    end, opts)
end

local root_dir = function()
    return vim.fn.getcwd()
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lsp_flags = { debounce_text_changes = 150 }

mason_lspconfig.setup_handlers {
    -- default handler
    function(server_name)
        lspconfig[server_name].setup {
            on_attach = on_attach,
            root_dir = root_dir,
            capabilities = capabilities,
            flags = lsp_flags,
        }
    end,
    ['efm'] = function(server_name)
        lspconfig[server_name].setup(vim.tbl_extend('force', efmls, {
            on_attach = on_attach,
            root_dir = root_dir,
            capabilities = capabilities,
            flags = lsp_flags,
        }))
    end,
    ['jsonls'] = function(server_name)
        lspconfig[server_name].setup {
            on_attach = on_attach,
            root_dir = root_dir,
            capabilities = capabilities,
            flags = lsp_flags,
            settings = {
                json = {
                    schemas = require('schemastore').json.schemas {
                        select = {
                            '.eslintrc',
                            'package.json',
                            'prettierrc.json',
                            'tsconfig.json',
                        },
                        replace = {
                            ['tsconfig.json'] = {
                                description = 'TypeScript compiler configuration file',
                                fileMatch = { 'tsconfig*.json' },
                                name = 'tsconfig.json',
                                url = 'https://json.schemastore.org/tsconfig.json',
                            },
                        },
                    },
                    validate = { enable = true },
                },
            },
        }
    end,
    ['lua_ls'] = function(server_name)
        lspconfig[server_name].setup {
            on_attach = on_attach,
            root_dir = root_dir,
            capabilities = capabilities,
            flags = lsp_flags,
            settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT',
                    },
                    diagnostics = {
                        globals = { 'vim' },
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file('', true),
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        }
    end,
    ['pyright'] = function(server_name)
        lspconfig[server_name].setup {
            on_attach = on_attach,
            root_dir = root_dir,
            capabilities = capabilities,
            flags = lsp_flags,
        }
    end,
    ['tsserver'] = function(server_name)
        lspconfig[server_name].setup {
            on_attach = on_attach,
            root_dir = root_dir,
            capabilities = capabilities,
            flags = lsp_flags,
            typescript = {
                tsserver = {
                    experimental = {
                        enableProjectDiagnostics = true,
                    },
                },
            },
        }
    end,
}

-----------------------------------------------------------
-- Diagnostics customization
-----------------------------------------------------------

-- Set diagnostic signs
vim.fn.sign_define(
    'DiagnosticSignError',
    { text = '󰅙', texthl = 'DiagnosticSignError' }
)
vim.fn.sign_define('DiagnosticSignWarn', { text = '󰀦', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '󰋼', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '󰌵', texthl = 'DiagnosticSignHint' })

-- Configure diagnostic options
vim.diagnostic.config {
    update_in_insert = true,
    severity_sort = true,
    virtual_text = false,
    signs = false,
    float = {
        header = '',
        suffix = '',
        format = function(item)
            local message = item.message

            local code = item.code
                or (item.user_data and item.user_data.lsp and item.user_data.lsp.code)

            local source = item.source
            local source_name = {
                ['typescript'] = 'ts',
                ['Lua Diagnostics.'] = 'lua',
                ['Lua Syntax Check.'] = 'lua',
            }

            if source_name[source] ~= nil then
                source = source_name[source]
            end

            return string.format('%s [%s] (%s)', message, source, code)
        end,
    },
}

-- Make all floating preview borders rounded by default
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or 'rounded'
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
