local g = vim.g
local o = vim.opt

-- Clipboard integration using win32yank
-- https://neovim.io/doc/user/provider.html#provider-clipboard

g.clipboard = {
    name = "win32yank",
    copy = {
        ["+"] = { "win32yank.exe", "-i", "--crlf" },
        ["*"] = { "win32yank.exe", "-i", "--crlf" },
    },
    paste = {
        ["+"] = { "win32yank.exe", "-o", "--lf" },
        ["*"] = { "win32yank.exe", "-o", "--lf" },
    },
    cache_enabled = false,
}

-- Use PowerShell as the default shell
o.shell = "pwsh.exe"
o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
o.shellquote = ""
o.shellxquote = ""

-- Add Scoop shims to PATH for user-installed utilities
local home = vim.loop.os_homedir()
local scoop = home .. "\\scoop\\shims"
vim.env.PATH = scoop .. ";" .. vim.env.PATH
