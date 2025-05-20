local cmp = require "cmp_nvim_lsp"

local caps = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    cmp.default_capabilities()
)

return {
    settings = {
        capabilities = caps,

        gopls = {
            analyses = { unusedparams = true },
            staticcheck = true,
        }
    }
}
