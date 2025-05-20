return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",

            "rouge8/neotest-rust",
            "nvim-neotest/neotest-go",
            "lawrence-laz/neotest-zig",
            "rcasia/neotest-bash",
        },

        config = function()
            require "neotest".setup {
                adapters = {
                    require "neotest-bash",
                    require "neotest-go",
                    require "neotest-rust",
                    require "neotest-zig",
                },

                consumers = {
                    overseer = require "neotest.consumers.overseer",
                },

                overseer = {
                    enabled = true,
                    force_default = false,
                },
            }
        end,
    },
}
