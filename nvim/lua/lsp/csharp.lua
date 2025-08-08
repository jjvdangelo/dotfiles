local util = require "lspconfig.util"

local root_dir = util.root_pattern "*.sln" (".") or util.root_pattern "*.csproj" (".")

require "lsp.config".setup("csharp_ls", {
    cmd = { "csharp-ls" },

    settings = {
        ["csharp_ls"] = {
            root_dir = root_dir,
            filetypes = { "cs" },
            init_options = { AutomaticWorkspaceInit = true },
        },
    },
})
