local m = require "utils.kmap"

vim.g.mapleader = " "

m.nmap("<leader>w", vim.cmd.write, "write current buffer to file")
m.nmap("<leader>qq", ":wqa", "write and quit all")

-- movement
m.nmap("H", "g^", "move to the end of the current line")
m.nmap("L", "g$", "move to the start of the current line")
m.nmap("j", "gj", "move up a line")
m.nmap("k", "gk", "move down a line")
m.nmap("<C-u>", "<C-u>zz", "jump up and center")
m.nmap("<C-d>", "<C-d>zz", "jump down and center")

-- navigation
m.nmap("<C-h>", "<C-w><C-h>", "navigate to window, left")
m.nmap("<C-j>", "<C-w><C-j>", "navigate to window, down")
m.nmap("<C-k>", "<C-w><C-k>", "navigate to window, up")
m.nmap("<C-l>", "<C-w><C-l>", "navigate to window, right")

m.nmap("<C-Left>", ":tabp<cr>", "navigate to previous tab")
m.nmap("<C-Right>", ":tabn<cr>", "navigate to next tab")

-- Going to try using `<leader><leader>` to show `Telescope diagnostics`
-- m.nmap("<leader><leader>", "<C-^>", "swap to previous buffer in current window")
m.nmap("<Right>", ":bn<cr>", "show next buffer in current window")
m.nmap("<Left>", ":bprev<cr>", "show previous buffer in the current window")

-- move lines up and down
local nv = { "n", "v" }
m.map(nv, "<A-j>", ":m .+1<cr>==", "move current line up")
m.map(nv, "<A-k>", ":m .-2<cr>==", "move current line down")

-- move visual selection up and down
m.vmap("<A-j>", ":m '>+1<cr>gv=gv", "move visual selection down a line")
m.vmap("<A-k>", ":m '>-2<cr>gv=gv", "move visual selection up a line")

-- easy transition back into normal mode
m.imap("jj", "<C-[>", "shortcut for <esc> or <C-[>")

-- move windows while in terminal mode
m.tmap("<C-h>", "<C-\\><C-n><C-w><C-h>", "move to next window, left")
m.tmap("<C-j>", "<C-\\><C-n><C-w><C-j>", "move to next window, below")
m.tmap("<C-k>", "<C-\\><C-n><C-w><C-k>", "move to next window, up")
m.tmap("<C-l>", "<C-\\><C-n><C-w><C-l>", "move to next window, right")
m.tmap("<Esc><Esc>", "<C-\\><C-n>", "enter normal mode")

m.tmap("jj", "<C-\\><C-n>", "enter normal mode")

-- utility
m.nmap("<leader>cc", require "utils.cc".toggle, "toggle colorcolumn")
m.nmap("<leader>h", require "utils.hlsearch".toggle, "toggle hlsearch")
m.nmap("<C-w>n", require "utils.hsplit".keep_buffer, "create vertical split, keeping current buffer")
m.nmap("<leader>bd", require "utils.buffers".kill_others, "destroy all buffers except the one in the current window")
