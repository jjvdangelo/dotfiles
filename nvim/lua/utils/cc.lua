local M = {}

local function toggle()
    local colorcolumn = vim.opt.colorcolumn:get()
    local new_value = ""

    if #colorcolumn == 0 or colorcolumn[1] == "" then
        new_value = '100'
    end

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        vim.api.nvim_set_option_value("colorcolumn", new_value, { win = win })
    end
end

M.toggle = toggle

return M
