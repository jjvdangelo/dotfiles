return {
    {
        "mason-org/mason.nvim",
        opts = {
            ui = {
                border = "rounded",
                icons = {
                    package_installed   = "✓",
                    package_pending     = "➜",
                    package_uninstalled = "✗",
                },
            },
        }
    },

    {
        "mason-org/mason-lspconfig.nvim",

        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },

        opts = {
            ensure_installed = {
                "gopls", "html", "htmx", "lua_ls", "postgres_lsp",
                "rust_analyzer", "templ", "ts_ls", "zls",
            },
        },
    },

    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            { "saadparwaiz1/cmp_luasnip" },
            { "rafamadriz/friendly-snippets" },
        },

        init = function ()
            require "luasnip"
            require "luasnip.loaders.from_vscode".lazy_load()
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",

        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "L3MON4D3/LuaSnip" }
        },

        config = function()
            local cmp = require "cmp"
            local s_beh = cmp.SelectBehavior.Select
            local cfg = { behavior = s_beh }
            local select_conf = { select = true, behavior = s_beh }
            local border = cmp.config.window.bordered("rounded")

            cmp.setup {
                snippet = {
                    expand = function (args)
                        require "luasnip".lsp_expand(args.body)
                    end,
                },

                window = {
                    completion = border, documentation = border,
                },

                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(cfg),
                    ["<C-p>"] = cmp.mapping.select_prev_item(cfg),
                    ["<C-y>"] = cmp.mapping.confirm(select_conf),
                    ["<C-.>"] = cmp.mapping.open_docs(),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<esc>"] = cmp.mapping.close(),
                }),

                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "path" },
                    { name = "buffer" },
                }),
            }
        end,
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/nvim-cmp" },
        },

        init = function()
            vim.diagnostic.config {
                virtual_text = true,
                float = { border = "rounded" },
            }
        end,
    },
}
