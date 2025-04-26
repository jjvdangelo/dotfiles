local as = require('auto-session')

local function should_restore_session()
    local cwd = vim.fn.getcwd()

    if vim.fn.argc() > 0 then
        local first_arg = vim.fn.argv(0)
        if first_arg == "." or first_arg == cwd then
            return true
        end

        return false
    end

    if cwd and cwd:match("%.git") then
        return false
    end

    return true
end

as.setup({
    use_git_branch = true,
    auto_session_enabled = true,
    auto_restore_last_session = should_restore_session(),
    auto_session_create_enabled = true,
    auto_session_enable_last_session = true,
    supressed_dirs = { '~/', '~/src', '~/Downloads' },
})
