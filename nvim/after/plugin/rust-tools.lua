local extraArgs = {
    "--",
    "-D", "clippy::missing_safety_doc",
}

require "rust-tools".setup {
    tools = {
        runnables = {
            use_telescope = true,
        },

        inlay_hints = {
            auto = true,
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    server = {
        settings = {
            ["rust-analyzer"] = {
                check = {
                    features = "all",
                    command = "clippy",
                    extraArgs = extraArgs,
                },
            },
        },
    },
}
