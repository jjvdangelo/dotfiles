-- if vim.fn.executable("pwsh") then
--     vim.opt.shell = "pwsh"
--     vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
--     vim.opt.shellquote = "\""
--     vim.opt.shellxquote = "\""
--     vim.opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
--     vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
-- end

if vim.fn.has("nvim") then
    vim.opt.guicursor = "n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor"
    vim.opt.inccommand = "nosplit"
end
