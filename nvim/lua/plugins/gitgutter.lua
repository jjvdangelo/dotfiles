return {
    {
        "airblade/vim-gitgutter",

        init = function()
            vim.g.gitgutter_grep = "rg"
        end,
    },
}
