require 'poimandres'.setup {
    dim_nc_background = true,
    disable_background = true,
    disable_float_background = true,
    disable_italics = true,
}

vim.cmd("highlight clear")
vim.cmd("syntax reset")

vim.o.background = "dark"
vim.o.termguicolors = true

vim.cmd.colorscheme("poimandres")

vim.cmd [[
    hi NormalFloat guibg=#1b1e28
    hi FloatBorder guifg=#89DDFF guibg=#1b1e28
    hi LspSignatureActiveParameter guifg=#89DDFF guibg=#1b1e28 gui=bold
]]

local highlights = vim.api.nvim_get_hl(0, {})
for group, attrs in pairs(highlights) do
    if attrs.italic then
        local updated = vim.tbl_extend("force", attrs, { italic = false })
        vim.api.nvim_set_hl(0, group, updated)
    end
end
