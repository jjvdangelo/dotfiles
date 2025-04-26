vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.history = 1000
vim.opt.undolevels = 1000

vim.opt.scrolloff = 8

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.updatetime = 50
vim.opt.timeoutlen = 300
vim.opt.encoding = "utf-8"

vim.opt.wildmenu = false
vim.opt.wildmode = "list:full"
vim.opt.wildignore = "*.swp,*.bak,*.pyc,*.class,Session.vim"

vim.opt.mouse = "a"

vim.o.completeopt = "menuone,noinsert,noselect"

vim.opt.shortmess = vim.opt.shortmess + 'c'

vim.o.sessionoptions = "buffers,curdir,folds,tabpages,winsize,winpos,terminal,localoptions"

vim.opt.diffopt:append({ "filler", "context:4", })
