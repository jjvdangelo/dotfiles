-- Install Packer if it hasn't been installed yet
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packers/start/packer.nvim'

    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({
            'git',
            'clone',
            '--depth',
            '1',
            'https://github.com/wbthomason/packer.nvim',
            install_path,
        })

        vim.cmd([[packadd packer.nvim]])
        return true
    end

    return false
end

local packer_bootstrap = ensure_packer()

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'simrat39/rust-tools.nvim'
    use 'rmagatti/auto-session'

    use {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    }

    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } },
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
    }

    use {
        'vrischmann/tree-sitter-templ',
        requires = {
            { 'nvim-treesitter/nvim-treesitter' },
        },
        config = function()
            vim.filetype.add({
                extension = { templ = "templ", },
            })
        end
    }

    use {
        'neovim/nvim-lspconfig',
        requires = {
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
        },
    }

    use {
        'nvim-neotest/neotest',
        requires = {
            'nvim-neotest/nvim-nio',
            'nvim-lua/plenary.nvim',
            'antoinemadec/FixCursorHold.nvim',
            'nvim-treesitter/nvim-treesitter',

            'rouge8/neotest-rust',
            'nvim-neotest/neotest-go',
            'Issafalcon/neotest-dotnet',
            'lawrence-laz/neotest-zig',
            'rcasia/neotest-bash',
        },
    }

    use {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = function()
            require('nvim-autopairs').setup {}
        end,
    }

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true, },
        config = function()
            require('lualine').setup {
                theme = 'poimandres'
            }
        end,
    }

    -- git
    use {
        'akinsho/git-conflict.nvim',
        tag = '*',
        config = function()
            require 'git-conflict'.setup {}
        end,
    }

    -- colorschemes
    use 'olivercederborg/poimandres.nvim'
    use 'chriskempson/base16-vim'
    use {
        'shaunsingh/nord.nvim',
        config = function()
            vim.g.nord_italic = false
            vim.g.nord_bold = false
            vim.g.nord_borders = true
        end,
    }
end)

vim.cmd [[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost packer.lua source <afile> | PackerCompile
    augroup end
]]

-- First run will install Packer and the configured plugins
if packer_bootstrap then
    require('packer').sync()
end
