return {
    {
        "mfussenegger/nvim-dap",

        init = function()
        end,
    },

    {
        "leoluz/nvim-dap-go",
        dependencies = { "mfussenegger/nvim-dap" },

        opts = {
            dap_configurations = {
                {
                    type = "go",
                    name = "Attach remote",
                    mode = "remove",
                    request = "attach",
                }
            },

            tests = { verbose = true },
        },
    },

    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },

        opts = {},

        init = function()
            local dap, dapui = require "dap", require "dapui"
            local before = dap.listeners.before

            local function open() dapui.open() end
            local function close() dapui.close() end

            before.attach.dapui_config = open
            before.launch.dapui_config = open
            before.event_terminated.dapui_config = close
            before.event_existed.dapui_config = close
        end,
    },
}
