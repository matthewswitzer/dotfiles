-----------------------------------------------------------
-- Completion Configuration
-----------------------------------------------------------

return {

    -- autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'f3fora/cmp-spell',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets',
            'onsails/lspkind.nvim',
        },
        opts = function()
            local cmp = require 'cmp'
            local lspkind = require 'lspkind'
            local luasnip = require 'luasnip'

            return {
                preselect = cmp.PreselectMode.None,
                completion = {
                    keyword_length = 1,
                },
                window = {
                    completion = cmp.config.window.bordered {
                        winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
                    },
                    documentation = cmp.config.window.bordered {
                        winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
                    },
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                formatting = {
                    format = lspkind.cmp_format {
                        mode = 'symbol_text',
                    },
                },
                mapping = {
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-u>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                    },
                    ['<Tab>'] = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end,
                    ['<S-Tab>'] = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end,
                },
                sources = {
                    { name = 'nvim_lsp_signature_help', priority = 6 },
                    { name = 'nvim_lsp', priority = 5 },
                    { name = 'nvim_lua', priority = 5 },
                    { name = 'luasnip', priority = 4 },
                    { name = 'path', priority = 3 },
                    { name = 'buffer', priority = 2, keyword_length = 3 },
                    {
                        name = 'spell',
                        priority = 1,
                        keyword_length = 3,
                        option = {
                            keep_all_entries = false,
                            enable_in_context = function()
                                return true
                            end,
                            preselect_correct_word = false,
                        },
                    },
                },
            }
        end,
        config = function(_, opts)
            local cmp = require 'cmp'
            local cmp_autopairs = require 'nvim-autopairs.completion.cmp'

            cmp.setup(opts)

            -- Search sources
            cmp.setup.cmdline('/', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' },
                },
            })

            -- Command sources
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources {
                    { name = 'path' },
                    { name = 'cmdline' },
                },
            })

            -- Insert brackets after confirming completion selection
            cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

            --  Lazy load friendly snippets based on filetype
            require('luasnip.loaders.from_vscode').lazy_load()
        end,
    },
}
