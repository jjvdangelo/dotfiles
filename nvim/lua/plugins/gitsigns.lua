return {
    {
        "lewis6991/gitsigns.nvim",

        opts = {
            attach_to_untracked = true,
            preview_config = {
                style = "minimal",
                relative = "cursor",
            },
            signs = {
                add          = { text = "▎" },
                change       = { text = "▎" },
                delete       = { text = "" },
                topdelete    = { text = "" },
                changedelete = { text = "▎" },
                untracked    = { text = '┆' },
            },
            signs_staged = {
                add          = { text = "▎" },
                change       = { text = "▎" },
                delete       = { text = "" },
                topdelete    = { text = "" },
                changedelete = { text = "▎" },
                untracked    = { text = '┆' },
            },
        },
    },
}
