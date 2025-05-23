return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })()
        end,

        config = function()
            require "nvim-treesitter.configs".setup {
                ensure_installed = {
                    "bash", "dockerfile", "go", "gomod", "gosum", "gotmpl",
                    "html", "javascript", "lua", "markdown", "markdown_inline",
                    "nginx", "powershell", "query", "robots", "rust", "sql",
                    "ssh_config", "templ", "todotxt", "toml", "typescript",
                    "xml", "yaml", "zig",
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = true,
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

        init = function()
            vim.filetype.add { extensions = { templ = "templ" } }
        end,
    },
}
