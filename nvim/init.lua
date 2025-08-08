local uname = vim.loop.os_uname().sysname

if uname == "Darwin" then
    require "config.macos"
elseif uname == "Windows_NT" then
    require "config.windows"
elseif uname == "Linux" then
    require "config.wsl"
end

require "config.settings"
require "config.keymap"
require "config.lazy"
require "config.multigrep"
require "lsp"
