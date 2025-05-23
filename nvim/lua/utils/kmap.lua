local M = {}

local opts = { silent = true, noremap = true }

local function map(mode, lhs, rhs, desc, o)
    o = vim.tbl_extend("force", opts, o or {})
    if desc ~= nil and desc ~= "" then
        o = vim.tbl_extend("force", { desc = desc }, o) -- keep o.desc if provided
    end
    vim.keymap.set(mode, lhs, rhs, o)
end

local function nmap(lhs, rhs, desc, o)
    map("n", lhs, rhs, desc, o)
end

local function imap(lhs, rhs, desc, o)
    map("i", lhs, rhs, desc, o)
end

local function vmap(lhs, rhs, desc, o)
    map("v", lhs, rhs, desc, o)
end

local function tmap(lhs, rhs, desc, o)
    map("t", lhs, rhs, desc, o)
end

M.opts = opts
M.map = map
M.nmap = nmap
M.imap = imap
M.vmap = vmap
M.tmap = tmap

return M
