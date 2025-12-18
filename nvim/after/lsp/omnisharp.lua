local util = require "lspconfig.util"

local home = vim.loop.os_homedir()
local path = vim.fs.joinpath(home, ".local", "omnisharp", "OmniSharp")

return {
    name = "omnisharp",

    cmd = {
        path,
        "-z",
        "DotNet:enablePackageRestore=false",
        "--languageserver",
        "--hostPID",
        tostring(vim.fn.getpid()),
        "--encoding",
        "utf-8",
    },

    filetypes = { "cs" },
    single_file_support = true,
    root_patterns = { "*.sln", "*.csproj", ".git" },

    settings = {
        FormattingOptions = { EnableEditorConfigSupport = true },
        MsBuild = { LoadProjectsOnDemand = false },
        RoslynExtensionsOptions = { EnableAnalyzerSupport = true, EnableImportCompletion = true },
        Sdk = { IncludePrereleases = true },
    },
}
