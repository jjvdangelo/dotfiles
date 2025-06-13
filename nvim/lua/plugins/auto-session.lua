local function get_cwd_as_name()
    local dir = vim.fn.getcwd(0)
    return dir:gsub("[^A-Za-z0-9]", "_")
end

return {
    {
        "rmagatti/auto-session",
        dependencies = {
            "stevearc/overseer.nvim",
            "nvim-lualine/lualine.nvim",
        },

        lazy = false,

        ---enables autocomplete for opts
        ---@module "auto-session"
        ---@type AutoSession.Config
        opts = {
            lazy_support = true,

            use_git_branch = true,
            git_use_branch_name = true,
            git_auto_restore_on_branch_change = true,

            auto_save = true,
            auto_restore = true,
            watch_for_changes = true,
            cwd_change_handling = true,
            skip_confirm_for_simple_edits = true,

            win_opts = { signcolumn = "yes", cursorcolumn = true, spell = true },
            post_cwd_changed_cmds = {
                function(opts)
                    return require "lualine".refresh(opts)
                end
            },
            view_options = { show_hidden = true, case_insensitive = true },
            lsp_file_methods = { autosave_changes = true },

            auto_delete_empty_session = true,
            close_unsupported_windows = true,

            session_lens = {
                load_on_setup = true,
                previewer = true,
                theme_conf = {
                    border = true,
                    layout_config = { width = 0.8, height = 0.75 },
                },
            },

            suppressed_dirs = { "~/", "~/src", "~/Downloads", "/" },
            disable_filetype = { "TelescopePrompt", "vim" },
        },

        init = function()
            vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
        end,
    },
}
