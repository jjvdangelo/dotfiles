local o = vim.opt

o.nu = true
o.relativenumber = true
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

o.hlsearch = true
o.incsearch = true

o.updatetime = 100
o.timeoutlen = 300
o.encoding = "utf-8"

o.wildmenu = true
o.wildmode = "list:full"
o.wildignore = "*.swp,*.bak,*.pyc,*.class,Session.vim"
o.wildoptions = "fuzzy,pum,tagfile"

o.mouse = "a"

o.completeopt = "menuone"
o.shortmess = o.shortmess + 'c'
o.sessionoptions = "buffers,curdir,folds,tabpages,winsize,winpos,terminal,localoptions"

o.diffopt:append({ "filler", "context:4", })
