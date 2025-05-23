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
            automatic_enable = true,
        },
    },

    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        dependencies = { "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets" },

        build = "make install_jsregexp",

        init = function()
            require "luasnip.loaders.from_vscode".lazy_load()
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip" },

        config = function()
            local cmp, lsnip = require "cmp", require "luasnip"
            local s_beh = cmp.SelectBehavior.Select
            local confirm_conf = { select = true, behavior = cmp.SelectBehavior.Insert }

            local function expand_snippet(args)
                lsnip.lsp_expand(args.body)
            end

            cmp.setup {
                snippet = { expand = expand_snippet },

                window = {
                    completion = cmp.config.window.bordered("rounded"),
                    documentation = cmp.config.window.bordered("rounded"),
                },

                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = s_beh }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = s_beh }),
                    ["<C-y>"] = cmp.mapping.confirm(confirm_conf),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<esc>"] = cmp.mapping.close(),

                    -- Visual Studio keybindings
                    ["<C-space>"] = cmp.mapping.confirm(confirm_conf),
                }),

                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "vim-dadbod-completion" },
                    { name = "buffer" },
                    { name = "path" },
                }),
            }
        end,
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/nvim-cmp" },

        init = function()
            vim.diagnostic.config {
                virtual_text = true,
                underline = true,
                float = { border = "rounded" },
            }
        end,
    },
}
