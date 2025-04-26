local saved_windows = {}

local function warn(msg)
    local title = { title = "FloatingTerm Warning", }
    local level = vim.log.levels.WARN
    vim.notify(msg, level, title)
end

local function ensure_valid_buffer(state)
    if not vim.api.nvim_buf_is_valid(state.buf) then
        state.buf = vim.api.nvim_create_buf(false, true)
    end
end

local function create_floating_window(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.65)
    local height = opts.height or math.floor(vim.o.lines * 0.65)

    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    local title_pos = nil
    if opts.title ~= nil or opts.title == "" then
        title_pos = opts.title_pos or "center"
    else
        if opts.title_pos ~= nil then
            warn("Float window 'title_pos' is ignored when 'title' is nil or an empty string")
        end
    end

    local win_config = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
        border = "rounded",
        title = opts.title,
        title_pos = title_pos,
    }

    local state = { buf = opts.buf, }
    ensure_valid_buffer(state)
    state.win = vim.api.nvim_open_win(state.buf, true, win_config)

    return state
end

local function hide_other_windows(curr)
    for _, state in pairs(saved_windows) do
        if state.floating ~= nil then
            if state.floating.win ~= curr and vim.api.nvim_win_is_valid(state.floating.win) then
                vim.api.nvim_win_hide(state.floating.win)
            end
        end
    end
end

local function toggle_window_show(state, title)
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        state.floating = create_floating_window { buf = state.floating.buf, title = title }

        hide_other_windows(state.floating.win)

        if vim.bo[state.floating.buf].buftype ~= "terminal" then
            vim.cmd.term()
        end
    else
        vim.api.nvim_win_hide(state.floating.win)
    end

    return state
end

local function new_state()
    local state = { floating = { buf = -1, win = -1, }, }
    ensure_valid_buffer(state.floating)
    return state
end

local function floating_term(opts)
    local args = opts.fargs
    local wid = args[1] or "temp_window"
    local title = args[2]
    local s = saved_windows[wid] or new_state()
    saved_windows[wid] = toggle_window_show(s, title)
end

vim.api.nvim_create_user_command("FloatingTerm", floating_term, { nargs = "*", })
