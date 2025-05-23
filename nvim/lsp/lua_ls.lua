return require "config.lsp-help".wrap_settings {
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
}
