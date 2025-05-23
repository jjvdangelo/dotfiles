return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        opts = {
            latex = { enable = false },

            injections = {
                gitcommit = {
                    enabled = true,
                    query = [[
                        ((message) @injection.content
                            (#set! injection.combined)
                            (#set! injection.include-children)
                            (#set! injection.language "markdown"))
                    ]],
                }
            },

            anti_conceal = {
                enabled = true,
                ignore = { code_background = true, sign = true },
            },
        },
    },

    {
        "iamcco/markdown-preview.nvim",

        build = "cd app && npm install",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },

        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
    },
}
