require "lsp.config".setup("rust_analyzer", {
    cmd = { "rust-analyzer" },

    settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module",
                allowMergingIntoGlobImports = true,
            },
            cargo = {
                loadOutDirsFromCheck = true,
                allFeatures = true,
                cfgs = { "debug_assertions", "miri" },
            },
            check = {
                command = "clippy",
                allTargets = true,
                extraArgs = {
                    "--workspace",
                },
            },
            procMacro = {
                enable = true,
            },
        },
    },
})
