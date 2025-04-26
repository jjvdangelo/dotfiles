local cmp = require('cmp')

local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
    sources = {
        { name = 'path' },
        { name = 'nvim_lsp', keyword_length = 2 },
        { name = 'buffer',   keyword_length = 2 },
        { name = 'vsnip',    keyword_length = 2 },
    },

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    mapping = {
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-.>'] = cmp.mapping.complete(),
        ['<C-u>'] = cmp.mapping.scroll_docs(4),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<esc>'] = cmp.mapping.close(),
        ['<cr>'] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Insert,
        }),
    },
})
