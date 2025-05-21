return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
            { "stevearc/overseer.nvim" },
        },

        opts = {
            theme = "catppuccin-frappe",

            sections = {
                lualine_x = {
                    {
                        "overseer",
                        colored = true,
                        unique = false,
                        name = nil,
                        name_not = false,
                        status = nil,
                        status_not = false,
                    },
                },
            },
        },
    }
}
