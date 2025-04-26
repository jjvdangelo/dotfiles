local config                            = require "lspconfig"
local cmp                               = require "cmp_nvim_lsp"

local capabilities                      = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    cmp.default_capabilities()
)

capabilities.textDocument.signatureHelp = {
    dynamicRegistration = false,
}

local on_attach                         = function(_, bufnr)
    local format_sync_grp = vim.api.nvim_create_augroup('Format', {})
    vim.api.nvim_create_autocmd('BufWritePre', {
        callback = function()
            vim.lsp.buf.format({ timeout_ms = 200 })
        end,

        group = format_sync_grp,
    })

    local opts = { buffer = bufnr, silent = true }
    local map = vim.keymap.set
    map("n", "gd", vim.lsp.buf.definition, opts)
    map("n", "gr", vim.lsp.buf.references, opts)
    map("n", "K", vim.lsp.buf.hover, opts)
    map("n", "<leader>rn", vim.lsp.buf.rename, opts)
    -- TODO: I don't know what to do for these at the moment.
    map("n", "<leader>ee", vim.diagnostic.open_float, opts)
    -- map("i", "", vim.diagnostic.open_float, opts)
end

config.omnisharp.setup {
    capabilities = capabilities,
    on_attach = on_attach,
}

config.zls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
}
config.html.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "html", },
}

config.ts_ls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
}

config.rust_analyzer.setup {
    capabilities = capabilities,
    on_attach = on_attach,
}

config.gopls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        gopls = {
            analyses = { unusedparams = true, },
            staticcheck = true,
        },
    },
}

config.lua_ls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT", },
            diagnostics = { globals = { "vim", }, },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = { enable = false, },
        },
    },
}

config.templ.setup {
    capabilities = capabilities,
    on_attach = on_attach,
}

local border = "rounded"
local handlerOptions = {
    border = border,
    close_events = { "CursorMoved", "InsertLeave" },
    focusable = false,
    relative = "cursor",
    row = -1,
    col = 0,
}
local h = vim.lsp.with(vim.lsp.handlers.signature_help, handlerOptions)

vim.lsp.handlers["textDocument/hover"] = h
vim.lsp.handlers["textDocument/signatureHelp"] = h

vim.diagnostic.config {
    float = { border = border },
}
