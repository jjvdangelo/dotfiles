local opts = { noremap = true, silent = false }
local sopts = { noremap = true, silent = true }
local map = vim.keymap.set

-- Trying out "oil" for file creation/management
local oil = require 'oil'
local function toggle_oil()
    oil.open_float(nil, { preview = { "vertical" } })
end

map("n", "<leader>e", toggle_oil, sopts)

-- map("n", "<leader>e", ":Telescope find_files<cr>", sopts)
map("n", "<leader>w", vim.cmd.write, sopts)
map("n", "<leader>qq", ":wqa", sopts)

map("n", "H", "g^", sopts)
map("n", "L", "g$", sopts)
map("n", "j", "gj", sopts)
map("n", "k", "gk", sopts)

map("n", "<C-j>", "<C-w><C-j>", sopts)
map("n", "<C-k>", "<C-w><C-k>", sopts)
map("n", "<C-h>", "<C-w><C-h>", sopts)
map("n", "<C-l>", "<C-w><C-l>", sopts)

map("n", "<leader><leader>", "<C-^>", sopts)
map("n", "<silent><Right>", ":bn<cr>", sopts)

map("n", "<Left>", ":bprev<cr>", sopts)
map("n", "<Right>", ":bnext<cr>", sopts)

map("n", "<leader>bd", ":%bd|e#<cr>", opts)

-- debugging
map("n", "<F8>", ":cnext<cr>", sopts)
map("n", "<F20>", ":cprev<cr>", sopts)

-- move lines up and down
map("n", "<A-j>", ":m .+1<cr>==", sopts)
map("n", "<A-k>", ":m .-2<cr>==", sopts)

-- move visual selection up and down
map("v", "<A-j>", ":m '>+1<cr>gv=gv")
map("v", "<A-k>", ":m '>-2<cr>gv=gv")

-- easy transition back into normal mode
map("i", "jj", "<esc>", opts)

map("t", "<C-j>", "<C-\\><C-n><C-w><C-j>", opts)
map("t", "<C-k>", "<C-\\><C-n><C-w><C-k>", opts)
map("t", "<C-h>", "<C-\\><C-n><C-w><C-h>", opts)
map("t", "<C-l>", "<C-\\><C-n><C-w><C-l>", opts)
map("t", "<Esc><Esc>", "<C-\\><C-n>", opts)
map("t", "jj", "<C-\\><C-n>", opts)

map({ "n", "t" }, "<leader>tt", ":FloatingTerm Terminal-0 Terminal<cr>", sopts)
map({ "n", "t" }, "<leader>11", ":FloatingTerm Terminal-1 Terminal-1<cr>", sopts)
map({ "n", "t" }, "<leader>22", ":FloatingTerm Terminal-2 Terminal-2<cr>", sopts)
map({ "n", "t" }, "<leader>33", ":FloatingTerm Terminal-3 Terminal-3<cr>", sopts)
map({ "n", "t" }, "<leader>44", ":FloatingTerm Terminal-4 Terminal-4<cr>", sopts)
map({ "n", "t" }, "<leader>55", ":FloatingTerm Terminal-5 Terminal-5<cr>", sopts)
map({ "n", "t" }, "<leader>66", ":FloatingTerm Terminal-6 Terminal-6<cr>", sopts)

local function toggle_colorcolumn()
    local colorcolumn = vim.opt.colorcolumn:get()
    local new_value = ""

    if #colorcolumn == 0 or colorcolumn[1] == "" then
        new_value = '100'
    end

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        vim.api.nvim_set_option_value("colorcolumn", new_value, { win = win })
    end
end
map("n", "<leader>cc", toggle_colorcolumn, opts)

local function toggle_hlsearch()
    ---@diagnostic disable:undefined-field
    vim.opt.hlsearch = not vim.opt.hlsearch:get()
end
map("n", "<leader>h", toggle_hlsearch, opts)

local function hsplit_keep_buffer()
    local buf = vim.api.nvim_get_current_buf()
    vim.cmd("new")
    vim.api.nvim_win_set_buf(0, buf)
end
map("n", "<C-w>n", hsplit_keep_buffer, sopts)
