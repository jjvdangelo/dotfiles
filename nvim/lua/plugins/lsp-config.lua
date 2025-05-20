return {
    {
        "hrsh7th/cmp-nvim-lsp",

        dependencies = { { "neovim/nvim-lspconfig" } },

        config = function()
            -- local c   = require "lspconfig"
            -- local cmp = require "cmp_nvim_lsp"

            vim.diagnostic.config {
                float = { source = "if_many", border = "rounded" },
            }

            -- local caps = vim.tbl_deep_extend(
            --     "force",
            --     vim.lsp.protocol.make_client_capabilities(),
            --     cmp.default_capabilities()
            -- )
            --
            -- local function on_attach(_, bufnr)
            --     local format_sync_group = vim.api.nvim_create_augroup("Format", {})
            --     vim.api.nvim_create_autocmd("BufWritePre", {
            --         callback = function()
            --             vim.lsp.buf.format({ timeout_ms = 200 })
            --         end,
            --
            --         group = format_sync_group,
            --     })
            --
            --     local opts = { buffer = bufnr, silent = true }
            --     local map = vim.keymap.set
            --     local buf = vim.lsp.buf
            --
            --     map("n", "gd", buf.definition, opts)
            --     map("n", "gr", buf.references, opts)
            --     map("n", "gi", buf.implementation, opts)
            --     map("n", "K", buf.hover, opts)
            --     map("n", "<leader>rn", buf.rename, opts)
            --     map("n", "<leader>ee", vim.diagnostic.open_float, opts)
            --     map("i", "<C-k>", vim.diagnostic.open_float, opts)
            -- end
            --
            -- local basic_opts = { capabilities = caps, on_attach = on_attach }
            -- local lsp_opts = {
            --     html = {
            --         settings = {
            --             ["html"] = { filetypes = { "html" } }
            --         },
            --     },
            -- }
            --
            -- local lsps = {
            --     { name = "html",         opts = lsp_opts.html },
            --     { name = "htmx" },
            --     { name = "postgres_lsp" },
            --     { name = "rust_analyzer" },
            --     { name = "templ" },
            --     { name = "ts_ls" },
            --     { name = "zls" },
            -- }
            --
            -- local function extend(opts)
            --     return vim.tbl_deep_extend("force", basic_opts, opts or {})
            -- end
            --
            -- for _, l in ipairs(lsps) do
            --     local opts = extend(l.opts)
            --     vim.lsp.config(l.name, opts)
            -- end
        end,
    },
}
