-----------------------------------------------------------
-- Language Server Protocol (LSP) Configuration
-----------------------------------------------------------

return {

    -- package manager
    {
        'mason-org/mason.nvim',
        cmd = 'Mason',
        keys = {
            -- open mason with <leader>m
            { '<Leader>M', '<Cmd>Mason<CR>', desc = 'Open Mason' },
        },
        build = ':MasonUpdate',
        opts = {
            ui = {
                icons = {
                    package_installed = '✓',
                    package_pending = '➜',
                    package_uninstalled = '✗',
                },
            },
        },
    },

    -- mason tool installer
    {
        'WhoIsSethDaniel/mason-tool-installer',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'mason.nvim',
        },
        opts = {
            ensure_installed = {
                -- LSP
                'awk-language-server',
                'basedpyright',
                'bash-language-server',
                'css-lsp',
                'dockerfile-language-server',
                'efm',
                'emmet-language-server',
                'eslint-lsp',
                'html-lsp',
                'json-lsp',
                'lua-language-server',
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
        },
        config = function(_, opts)
            require('mason-tool-installer').setup(opts)

            -- manually trigger :MasonToolsUpdate when the plugin is loaded
            vim.api.nvim_command 'MasonToolsUpdate'
        end,
    },

    -- lspconfig
    {
        'mason-org/mason-lspconfig.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'mason.nvim',
            'neovim/nvim-lspconfig',
            { 'creativenull/efmls-configs-nvim', version = 'v1.x.x' },
            'b0o/schemastore.nvim',
        },
        init = function()
            -- Set diagnostic signs
            vim.fn.sign_define(
                'DiagnosticSignError',
                { text = '󰅙', texthl = 'DiagnosticSignError' }
            )
            vim.fn.sign_define(
                'DiagnosticSignWarn',
                { text = '󰀦', texthl = 'DiagnosticSignWarn' }
            )
            vim.fn.sign_define(
                'DiagnosticSignInfo',
                { text = '󰋼', texthl = 'DiagnosticSignInfo' }
            )
            vim.fn.sign_define(
                'DiagnosticSignHint',
                { text = '󰌵', texthl = 'DiagnosticSignHint' }
            )

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
                            or (
                                item.user_data
                                and item.user_data.lsp
                                and item.user_data.lsp.code
                            )

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
            ---@diagnostic disable-next-line: duplicate-set-field
            function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
                opts = opts or {}
                opts.border = opts.border or 'rounded'
                return orig_util_open_floating_preview(contents, syntax, opts, ...)
            end
        end,
        config = function()
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
                awk = {
                    prettierd,
                },
                css = {
                    prettierd,
                },
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
                    prettierd,
                },
                python = {
                    flake8,
                    black,
                    isort,
                },
                scss = {
                    prettierd,
                },
                typescript = {
                    prettierd,
                },
                typescriptreact = {
                    prettierd,
                },
                yaml = {
                    prettierd,
                },
            }

            -- Use efm-ls configured formatting
            local lsp_formatter = function(bufnr)
                vim.lsp.buf.format {
                    filter = function(client)
                        local ftype = vim.filetype.match { buf = bufnr }
                        if efmlangs[ftype] ~= nil then
                            return client.name == 'efm'
                        else
                            return client.name == ftype
                        end
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

                client:exec_command(command, { bufnr = bufnr })
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
                    end,
                })

                -- show diagnostics on cursor hold
                vim.api.nvim_create_autocmd('CursorHold', {
                    buffer = bufnr,
                    callback = function()
                        local float_opts = {
                            focusable = false,
                            close_events = {
                                'BufLeave',
                                'CursorMoved',
                                'InsertEnter',
                                'FocusLost',
                            },
                            prefix = '',
                            scope = 'cursor',
                        }
                        vim.diagnostic.open_float(nil, float_opts)
                    end,
                })

                -- mappings
                local opts = { noremap = true, silent = true, buffer = bufnr }
                local map = vim.keymap.set
                map('n', 'K', vim.lsp.buf.hover, opts)
                map('n', 'gD', vim.lsp.buf.declaration, opts)
                map('n', 'gd', '<Cmd>Telescope lsp_definitions<CR>', opts)
                map('n', 'gi', '<Cmd>Telescope lsp_implementations<CR>', opts)
                map('n', 'gr', '<Cmd>Telescope lsp_references<CR>', opts)
                map('n', 'gt', '<Cmd>Telescope lsp_type_definitions<CR>', opts)
                map('n', '<Leader>rn', vim.lsp.buf.rename, opts)
                map('n', '<Leader>.', vim.lsp.buf.code_action, opts)
                map('n', '<Leader>,', vim.lsp.codelens.run, opts)
                map('n', ']g', function()
                    vim.diagnostic.jump { count = 1, float = false }
                end, opts)
                map('n', '[g', function()
                    vim.diagnostic.jump { count = -1, float = false }
                end, opts)
                map('n', '<C-f>', function()
                    lsp_formatter(bufnr)
                end, opts)
                map('n', '<C-o>', function()
                    organize_imports(client, bufnr)
                end, opts)
            end

            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            local lsp_flags = { debounce_text_changes = 150 }

            -- apply the same settings to ALL server configurations
            vim.lsp.config('*', {
                on_attach = on_attach,
                capabilities = capabilities,
                flags = lsp_flags,
            })

            -- efm
            vim.lsp.config('efm', {
                filetypes = vim.tbl_keys(efmlangs),
                settings = {
                    rootMarkers = { '.git/' },
                    languages = efmlangs,
                },
                init_options = {
                    documentFormatting = true,
                    documentRangeFormatting = true,
                },
            })

            -- jsonls
            vim.lsp.config('jsonls', {
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
            })

            -- lua_ls
            vim.lsp.config('lua_ls', {
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
            })

            -- typescript-language-server
            vim.lsp.config('ts_ls', {
                typescript = {
                    tsserver = {
                        experimental = {
                            enableProjectDiagnostics = true,
                        },
                    },
                },
            })

            require('mason').setup()
            require('mason-lspconfig').setup()
        end,
    },
}
