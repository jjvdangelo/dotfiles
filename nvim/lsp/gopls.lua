local h = require "config.lsp-help"

return require "config.lsp-help".wrap_settings {
    gopls = {
        analyses = { unusedparams = true },
        staticcheck = true,
    },
}
