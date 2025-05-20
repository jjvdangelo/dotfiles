local function get_cwd_as_name()
    local dir = vim.fn.getcwd(0)
    return dir:gsub("[^A-Za-z0-9]", "_")
end

return {
    {
        "rmagatti/auto-session",
        dependencies = { "stevearc/overseer.nvim" },

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
            post_cwd_changed_cmds = { require "lualine".refresh },
            view_options = { show_hidden = true, case_insensitive = true },
            lsp_file_methods = { autosave_changes = true },

            auto_delete_empty_session = true,
            close_unsupported_windows = true,

            session_lens = {
                load_on_setup = true,
                previewer = true,
                theme_conf = { border = true, layout_config = { width = 0.8, height = 0.75 } },
            },

            suppressed_dirs = { "~/", "~/src", "~/Downloads", "/" },
            disable_filetype = { "TelescopePrompt", "vim" },

            show_auto_restore_notif = true,

            pre_save_cmds = {
                function()
                    local overseer = require "overseer"

                    overseer.save_task_bundle(
                        get_cwd_as_name(),
                        nil,
                        { on_conflict = "overwrite" }
                    )
                end,
            },

            pre_restore_cmds = {
                function()
                    local overseer = require "overseer"
                    for _, task in ipairs(overseer.list_tasks {}) do
                        task:dispose(true)
                    end
                end,
            },

            post_restore_cmds = {
                function()
                    local overseer = require "overseer"

                    overseer.load_task_bundle(
                        get_cwd_as_name(),
                        { ignore_missing = true }
                    )
                end,
            },
        },

        init = function()
            vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

            vim.api.nvim_create_autocmd("VimEnter", {
                once = true,
                callback = function()
                    if vim.fn.empty(vim.v.this_session) == 1 then
                        if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
                            require "oil".open_float()
                        end
                    end
                end,
            })
        end,

        args_allow_files_auto_save = function()
            local supported = 0
            local bufs = vim.api.nvim_list_bufs()
            for _, buf in ipairs(bufs) do
                if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
                    local path = vim.api.nvim_buf_get_name(buf)
                    if vim.fn.filereadable(path) ~= 0 then supported = supported + 1 end
                end
            end

            return supported >= 2
        end,
    },
}
