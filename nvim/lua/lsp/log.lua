local M = {}

local levels = { error = 1, warn = 2, info = 3, debug = 4 }
local notify_levels = {
    error = vim.log.levels.ERROR,
    warn = vim.log.levels.WARN,
    info = vim.log.levels.INFO,
    debug = vim.log.levels.DEBUG,
}

local log = vim.fs.joinpath(vim.fn.stdpath("state"), "lsp-auto.log")
local function writeln(s)
    local ok, f = pcall(io.open, logfile, "a")
    if ok and f then
        f:write(s .. "\n")
        f:close()
    end
end

local function fmt(name, ...)
    local parts = {}
    for i = 1, select("#", ...) do
        local v = select(i, ...)
        parts[#parts+1] = type(v) == "string" and v or vim.inspect(v)
    end

    return string.format("[lsp-auto][%s] %s", name, table.concat(parts, " "))
end

local current = (function()
    local l = (vim.g.lsp_auto_log_level or "info"):lower()
    return levels[l] or levels.info
end)()

local function mk(name)
    local threshold = levels[name]
    return function(...)
        if current < threshold then
            return
        end

        local line = fmt(name, ...)
        writeln(line)
        if threshold <= levels.warn then
            vim.schedule(function()
                vim.notify(line, notify_levels[name])
            end)
        end
    end
end

function M.set_level(name)
    local l = (name or "info"):lower()
    current = levels[l] or levels.info
end

M.error = mk("error")
M.warn = mk("warn")
M.info = mk("info")
M.debug = mk("debug")
M.path = logfile

return M
