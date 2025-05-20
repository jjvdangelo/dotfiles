local function t() return true end

return {
    {
        "stevearc/oil.nvim",

        cmd = "Oil",

        ---@module "oil"
        ---@type oil.SetupOpts
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

        dependencies = { "nvim-tree/nvim-web-devicons", opts = {} },

        lazy = false,
    }
}
