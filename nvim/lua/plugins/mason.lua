return {
    {
        "mason-org/mason-lspconfig.nvim",

        dependencies = {
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
            "neovim/nvim-lspconfig",
        },

        opts = {
            ensure_installed = {
                "gopls", "html", "htmx", "lua_ls", "postgres_lsp",
                "rust_analyzer", "templ", "ts_ls", "zls",
            },
        },
    },
}
