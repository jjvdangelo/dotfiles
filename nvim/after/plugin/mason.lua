require "mason".setup()
require "mason-lspconfig".setup {
    automatic_installation = true,
    ensure_installed = {
        "rust_analyzer",
        "gopls",
        "html",
        "ts_ls",
        "lua_ls",
        "zls",
    },
}
