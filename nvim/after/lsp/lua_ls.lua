local util = require "lspconfig.util"
local home = vim.loop.os_homedir()
local exe = vim.fs.joinpath(home, ".local", "bin", "lua-language-server")

return {
    name = "lua_ls",
    cmd = { exe },
    filetypes = { "lua" },
    single_file_support = true,
    root_patterns = { { ".luarc.json", "luarc.jsonc" }, ".git" },

    settings = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = { globals = { "vim" } },
        },
    },
}
