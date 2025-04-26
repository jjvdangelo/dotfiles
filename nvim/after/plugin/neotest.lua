require('neotest').setup({
    adapters = {
        require 'neotest-bash',
        require 'neotest-dotnet',
        require 'neotest-go',
        require 'neotest-rust',
        require 'neotest-zig',
    },
})
