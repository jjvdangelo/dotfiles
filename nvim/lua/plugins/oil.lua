local function t() return true end

return {
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", opts = {} },
        lazy = false,

        opts = {
            view_options = { show_hidden = true },
            constrain_cursor = "editable",
            -- default_file_explorer = false,

            columns = { "icon", "permissions", "size", "mtime" },
            skip_confirm_for_simple_edits = true,

            git = { add = t, mv = t, rm = t, },

            cleanup_delay_ms = 750,
            watch_for_changes = true,
        },

        init = function()
            local oil = require "oil"
            local function toggle()
                oil.open_float(nil, { preview = { "vertical" } })
            end

            local m = require "utils.kmap"
            m.nmap("-", toggle, "toggle oil")

            local function oil_open_float()
                oil.open_float(nil, { preview = { "vertical" } })
            end
            m.nmap("<leader>e", oil_open_float, "open oil float")
        end,
    }
}
