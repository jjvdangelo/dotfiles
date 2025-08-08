return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            local install = require "nvim-treesitter.install"
            install.prefer_git = false
            install.update({ with_sync = true })()
        end,

        config = function()
            require "nvim-treesitter.configs".setup {
                ensure_installed = {},
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            }
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {},
    },

    {
        "vrischmann/tree-sitter-templ",
        dependencies = { "nvim-treesitter/nvim-treesitter" },

        config = function()
            vim.filetype.add { extensions = { templ = "templ" } }
        end,
    },
}
