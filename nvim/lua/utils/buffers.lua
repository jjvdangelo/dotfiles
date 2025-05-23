local M = {}

local function kill_others()
    vim.cmd("%bd|e#")
end

M.kill_others = kill_others

return M
