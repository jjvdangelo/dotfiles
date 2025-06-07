return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "leoluz/nvim-dap-go",
            "nvim-neotest/nvim-nio",
        },

        config = function()
            local m = require "utils.kmap"

            local dap, dapui = require "dap", require "dapui"
            local before = dap.listeners.before

            before.attach.dapui_config = dapui.open
            before.launch.dapui_config = dapui.open
            before.event_terminated.dapui_config = dapui.close
            before.event_exited.dapui_config = dapui.close

            m.nmap("<leader>dt", dap.toggle_breakpoint)
            m.nmap("<leader>dc", dap.continue)
            m.map({ "n", "i", "v" }, "<F9>", dap.toggle_breakpoint)
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
}
