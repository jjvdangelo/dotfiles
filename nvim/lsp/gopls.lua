return require "config.lsp-help".wrap_settings {
    gopls = {
        analyses = { unusedparams = true },
        staticcheck = true,
    },
}
