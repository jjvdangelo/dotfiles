return {
    {
        "hrsh7th/nvim-cmp",

        event = "InsertEnter",

        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "neovim/nvim-lspconfig" },
        },

        config = function()
            local cmp = require "cmp"
            local select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup {
                sources = {
                    { name = "path" },
                    { name = "nvim_lsp", },
                    { name = "buffer", },
                    { name = "vsnip", },
                    { name = "lazydev",  group_index = 0 },
                },

                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },

                mapping = {
                    ["<C-n>"] = cmp.mapping.select_next_item(select),
                    ["<C-p>"] = cmp.mapping.select_prev_item(select),
                    ["<C-.>"] = cmp.mapping.complete(),
                    ["<C-u>"] = cmp.mapping.scroll_docs(4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<esc>"] = cmp.mapping.close(),
                    ["<cr>"] = cmp.mapping.confirm({
                        select = true,
                        behavior = cmp.ConfirmBehavior.Insert,
                    }),
                },
            }
        end,
    }
}
