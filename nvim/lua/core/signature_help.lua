local M = {}

local signature_enabled = true

M.toggle_signature = function()
    signature_enabled = not signature_enabled
    vim.notify("Signature Help: " .. (signature_enabled and "Enabled" or "Disabled"))
end

vim.api.nvim_create_autocmd("TextChangedI", {
    pattern = "*",
    callback = function()
        if not signature_enabled then return end
        local col = vim.fn.col(".") - 1
        local line = vim.fn.getline(".")
        local char = col > 0 and line:sub(col, col)
        if char == "(" or char == "," then
            vim.defer_fn(vim.lsp.buf.signature_help, 0)
        end
    end,
})

return M
