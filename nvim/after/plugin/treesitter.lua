local tsc = require "nvim-treesitter.configs"

---@diagnostic disable: missing-fields
tsc.setup {
    ensure_installed = {
		"dockerfile", "go", "gomod", "gosum", "gotmpl", "html", "javascript", "lua", "markdown",
		"markdown_inline", "powershell", "query", "robots", "rust", "sql", "ssh_config", "templ",
		"todotxt", "toml", "xml", "yaml", "zig", "bash", "nginx", "typescript",
    },

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

vim.filetype.add({ extension = { templ = "templ", }, })
