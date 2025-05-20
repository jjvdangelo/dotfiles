return {
    {
        "catppuccin/nvim",

        name = "catppuccin",

        lazy = false,
        priority = 1000,

        opts = {
            flavour = "frappe",

            no_italic = true,
            term_colors = true,
            show_end_of_buffer = true,
            transparent_background = true,
            background = { light = "latte", dark = "frappe" },

            integrations = {
                fzf = true,
                mason = true,
                neotest = true,
                overseer = true,
                dadbod_ui = true,
                gitgutter = true,
                which_key = true,
                render_markdown = true,

                native_lsp = {
                    enabled = true,
                    inlay_hints = { background = false },

                    virtual_text = {
                        errors = { "bold" },
                        hints = {},
                        warnings = { "bold" },
                        information = {},
                        ok = {},
                    },

                    underlines = {
                        errors = { "underline" },
                        hints = {},
                        warnings = { "underline" },
                        information = {},
                        ok = {},
                    },
                },
            },
        },

        init = function()
            vim.cmd "highlight clear"
            vim.cmd "syntax reset"

            vim.o.termguicolors = true
            vim.o.background = "dark"

            vim.cmd.colorscheme "catppuccin-frappe"
        end,
    },
}
