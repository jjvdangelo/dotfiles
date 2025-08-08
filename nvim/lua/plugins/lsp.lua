return {
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        dependencies = { "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets" },
        build = "make install_jsregexp",

        config = function()
            require "luasnip.loaders.from_vscode".lazy_load()
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-cmdline", "L3MON4D3/LuaSnip" },

        config = function()
            local cmp, lsnip = require "cmp", require "luasnip"
            local select_opts = { behavior = cmp.SelectBehavior.Select }
            local confirm_conf = { select = true, behavior = cmp.SelectBehavior.Insert }
            local window_bordered = cmp.config.window.bordered("rounded")

            local function expand_snippet(args)
                lsnip.lsp_expand(args.body)
            end

            local function snip_placeholder(i)
                local function callback(fallback)
                    if lsnip.jumpable(i) then
                        lsnip.jump(i)
                    elseif fallback then
                        fallback()
                    end
                end

                return callback
            end

            cmp.setup {
                snippet = { expand = expand_snippet },

                window = { completion = window_bordered, documentation = window_bordered },

                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(select_opts),
                    ["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
                    ["<C-y>"] = cmp.mapping.confirm(confirm_conf),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<esc>"] = cmp.mapping.close(),

                    -- ["<C-f>"] = cmp.mapping(snip_placeholder(1), { "i", "s" }),
                    -- ["<C-b>"] = cmp.mapping(snip_placeholder(-1), { "i", "s" }),
                    ["<tab>"] = cmp.mapping(snip_complete, { "i", "s" }),
                }),

                sources = cmp.config.sources({
                    { name = "path" },
                    { name = "nvim_lsp", keyword_length = 1 },
                    { name = "buffer", keyword_length = 3 },
                    { name = "luasnip", keyword_length = 2 },
                    { name = "vim-dadbod-completion", keyword_length = 1 },
                }),
            }

            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                source = { { "buffer" } },
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                })
            })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/nvim-cmp" },

        config = function()
            vim.diagnostic.config {
                virtual_text = false,
                underline = true,
                severity_sort = true,
                float = { border = "rounded", source = true },
            }
        end,
    },
}
