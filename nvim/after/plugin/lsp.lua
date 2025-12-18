local lsp_auto = require "lsp.auto"
local log = require "lsp.log"

local function start_for_buf(bufnr)
    if not vim.api.nvim_buf_is_loaded(bufnr) then
        return
    end

    if vim.bo[bufnr].buftype ~= "" then
        return
    end

    if vim.bo[bufnr].filetype == "" then
        return
    end

    log.debug("kick for", vim.api.nvim_buf_get_name(bufnr), "ft=", vim.bo[bufnr].filetype)
    lsp_auto.start()
end

vim.schedule(function()
    log.info("VimEnter scheduled scan")
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
        start_for_buf(b)
    end
end)

vim.api.nvim_create_autocmd({ "FileType", "BufReadPost", "BufNewFile" }, {
    callback = function(args)
        log.debug("autocmd", args.event, "buf=", args.buf)
        start_for_buf(args.buf)
    end,
})

vim.api.nvim_create_user_command("LspStartAll", function()
    log.info("manual LspStartAll")
    lsp_auto.start()
end, {})

vim.api.nvim_create_user_command("LspAutoLogOpen", function()
    local path = log.path
    local ok, f = pcall(io.open, path, "w")
    if ok and f then f:close() end
    vim.notify("Cleared " .. path, vim.log.levels.INFO)
end, {})
