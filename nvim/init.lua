local uname = vim.loop.os_uname().sysname

if uname == "Darwin" then
    require "config.macos"
elseif uname == "Windows_NT" then
    require "config.windows"
elseif uname == "Linux" then
    if vim.fn.getenv("WSL_DISTRO_NAME") ~= vim.NIL then
        require "config.wsl"
    else
        require "config.linux"
    end
end

require "config.settings"
require "config.keymap"
require "config.lazy"
require "config.multigrep"
require "lsp"
