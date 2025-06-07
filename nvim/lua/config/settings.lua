local g = vim.g

g.has_ui = #vim.api.nvim_list_uis() > 0
g.has_gui = vim.fn.has('gui_running') == 1
g.has_display = g.has_ui and vim.env.DISPLAY ~= nil
g.has_nf = vim.env.TERM ~= 'linux' and vim.env.NVIM_NF and true or false


local o = vim.opt

o.nu = true
o.relativenumber = true
o.cursorlineopt = "both"
o.cursorline = true

o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true

o.swapfile = false
o.backup = false
o.undofile = true
o.history = 1000
o.undolevels = 1000

o.scrolloff = 8
o.sidescrolloff = 8
o.signcolumn = "yes:1"

o.splitright = true
o.splitbelow = true

o.breakindent = true

o.hlsearch = true
o.incsearch = true
o.smartcase = true
o.ignorecase = true
o.completeopt = "menuone,popup,preview,fuzzy"
o.tagcase = "followscs"

o.jumpoptions = "clean"

o.updatetime = 100
o.timeoutlen = 300
o.encoding = "utf-8"

o.wildmenu = false
o.wildmode = "list:full"
o.wildignore = "*.swp,*.bak,*.pyc,*.class,Session.vim"
o.wildoptions = "fuzzy,pum,tagfile"

o.mouse = "a"

o.completeopt = "menu,menuone,noselect"
o.shortmess:append('c')
o.sessionoptions = "buffers,curdir,folds,tabpages,winsize,winpos,localoptions"

o.diffopt:append({
    "filler",
    "context:4",
    "algorithm:histogram",
    "indent-heuristic",
    "linematch:60",
})

o.formatoptions:append("norm")

o.spellsuggest = "best,9"
o.spellcapcheck = ""
o.spelllang = "en"
o.spelloptions = "camel"

if vim.fn.has("nvim") then
    o.guicursor = {
        "n-v-c:block-Cursor/lCursor-blinkon0",
        "i-c-ci:ver25-Cursor/lCursor",
        "o:hor50-Cursor/lCursor",
        "r-cr:hor20-Cursor/lCursor",
    }
    o.inccommand = "split"
    o.termguicolors = true
end

vim.cmd([[exec "map \e. <c-.>"]])

local au = require "utils.au"
au.group("OptShada", function(autocmd, grp)
    autocmd("BufReadPre", {
        once = true,
        callback = function()
            pcall(vim.api.nvim_del_augroup_by_id, grp)
            o.shada = vim.api.nvim_get_option_info2("shada", {}).default
            pcall(vim.cmd.shada)
        end,
    })
end)
