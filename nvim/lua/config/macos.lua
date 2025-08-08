local g = vim.g

-- Clipboard integration using pbcopy/pbpaste
-- Avoid caching to ensure real-time sync
-- https://neovim.io/doc/user/provider.html#provider-clipboard

g.clipboard = {
    name = "macOS-Clipboard",
    copy = { ["+"] = { "pbcopy" }, ["*"] = { "pbcopy" } },
    paste = { ["+"] = { "pbpaste" }, ["*"] = { "pbpaste" } },
    cache_enabled = false,
}

-- Ensure Homebrew binaries are available in PATH
local paths = { "/opt/homebrew/bin", "/opt/homebrew/sbin" }
for _, p in ipairs(paths) do
    if vim.fn.isdirectory(p) == 1 and not vim.env.PATH:find(p, 1, true) then
        vim.env.PATH = p .. ":" .. vim.env.PATH
    end
end
