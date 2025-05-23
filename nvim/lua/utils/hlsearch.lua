local M = {}

local function toggle()
    ---@diagnostic disable:undefined-field
    vim.opt.hlsearch = not vim.opt.hlsearch:get()
end

M.toggle = toggle

return M
