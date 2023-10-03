-----------------------------------------------------------
-- Autocompletion Configuration
-----------------------------------------------------------

local cmp = require 'cmp'
local lspkind = require 'lspkind'
local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
local luasnip = require 'luasnip'

-----------------------------------------------------------
-- Completion setup
-----------------------------------------------------------

cmp.setup {
    completion = {
        completeopt = 'menu,menuone,noinsert',
        keyword_length = 2,
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
            require('luasnip').lsp_expand(args.body)
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
            select = true,
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
        { name = 'nvim_lsp_signature_help', priority = 5 },
        { name = 'nvim_lsp', priority = 4 },
        { name = 'nvim_lua', priority = 4 },
        { name = 'luasnip', priority = 3 },
        { name = 'path', priority = 2 },
        { name = 'buffer', priority = 1, keyword_length = 3 },
    },
}

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

-----------------------------------------------------------
-- Luasnip setup
-----------------------------------------------------------

local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node

-- TypeScript snippets
luasnip.add_snippets('typescript', {
    s('nominal', {
        t 'export type ',
        i(1, 'TypeName'),
        t ' = ',
        i(2, 'string'),
        f(function(args)
            return " & B.Brand<'" .. args[1][1] .. "'>"
        end, { 1 }),
        i(0),
    }),
})

--  Lazy load friendly snippets based on filetype
require('luasnip.loaders.from_vscode').lazy_load()
