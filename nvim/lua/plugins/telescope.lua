return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "jonarrien/telescope-cmdline.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
            "nvim-telescope/telescope-dap.nvim",
            {
                "nvim-telescope/telescope-ui-select.nvim",
                opts = { overseer = { enabled = true } },
            },
        },

        keys = {
            { "Q", "<cmd>Telescope cmdline<cr>", desc = "CmdLine" }
        },

        config = function()
            local ts = require "telescope"
            ts.setup {
                extensions = {
                    ["ui-select"] = { require "telescope.themes".get_dropdown {} },

                    cmdline = {
                        mappings = {
                            complete = "<tab>",
                            run_selection = "<c-cr>",
                            run_input = "<cr>",
                        },
                    },
                },
            }

            ts.load_extension("ui-select")
            ts.load_extension("cmdline")
            ts.load_extension("dap")
        end,
    },

    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build =
        "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    },
}
