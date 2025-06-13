if vim.fn.getenv("WSL_DISTRO_NAME") ~= vim.NIL then
    local clip = { "/mnt/c/WINDOWS/system32/clip.exe" }
    local pwsh = "/mnt/c/PowerShell/7/pwsh.exe"
    local pwsh_args = '[Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'
    local pwsh_cmd = { pwsh, "-c", pwsh_args }

    vim.g.clipboard = {
        name = "WSL Clipboard",
        cache_enabled = false,

        copy = { ["+"] = clip, ["*"] = clip, },
        paste = { ["+"] = pwsh_cmd, ["*"] = pwsh_cmd, },
    }
end
