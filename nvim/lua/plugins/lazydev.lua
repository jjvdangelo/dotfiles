return {
    {
        "folke/lazydev.nvim",
        dependencies = { "justinsgithub/wezterm-types" },

        ft = "lua",

        opts = {
            library = {
                "lazy.nvim",
                { path = "nvim-dap-ui" },
                { path = "LazyVim",       words = { "LazyVim" } },
                { path = "wezterm-types", mods = { "wezterm" } },
            },
        },
    },
}
