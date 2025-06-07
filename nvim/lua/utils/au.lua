local M = {}

-- Extended from https://mskelton.dev/bytes/easier-auto-command-groups-in-neovim
local function group(name, func)
    local ag = vim.api.nvim_create_augroup(name, {})

    local function autocmd(event, opts)
        vim.api.nvim_create_autocmd(
            event,
            vim.tbl_extend("keep", opts, { group = ag })
        )
    end

    func(autocmd, ag)
end

M.group = group

return M
