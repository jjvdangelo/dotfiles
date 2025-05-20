local cmp = require "cmp_nvim_lsp"

local caps = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    cmp.default_capabilities()
)

return {
    settings = {
        capabilities = caps,

        Lua = {
            runtime = { version = "LuaJIT" },

            workspace = {
                checkThirdParty = false,

                library = {
                    vim.env.VIMRUNTIME,
                    vim.fn.stdpath("config"),
                },
            },

            diagnostics = { globals = { "vim" } },
            telemetry = { enable = false },
        },
    },
}
