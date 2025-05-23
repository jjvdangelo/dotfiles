local M = {}

local function keep_buffer()
    local buf = vim.api.nvim_get_current_buf()
    vim.cmd("new")
    vim.api.nvim_win_set_buf(0, buf)
end

M.keep_buffer = keep_buffer

return M
