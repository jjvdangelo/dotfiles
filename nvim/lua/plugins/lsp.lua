return {
    {
        "neovim/nvim-lspconfig",
        dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/nvim-cmp" },

        config = function()
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        diagnostics = { globals = { "vim", "require" } },
                        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                        telemetry = { enable = false },
                    },
                },
            })

            vim.diagnostic.config {
                virtual_text = false,
                underline = true,
                severity_sort = true,
                float = { border = "rounded", source = true },
            }
        end,
    },
}
