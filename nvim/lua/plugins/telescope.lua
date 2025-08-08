return {
    {
        "nvim-telescope/telescope-ui-select.nvim",
        opts = { overseer = { enabled = false } },
    },

    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "jonarrien/telescope-cmdline.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
            "nvim-telescope/telescope-dap.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
        },

        config = function()
            local ts = require "telescope"
            local k = require "utils.kmap"
            local ta = require "telescope.actions"
            local tele = require "telescope.builtin"

            ts.load_extension("ui-select")
            ts.load_extension("cmdline")
            ts.load_extension("dap")

            k.nmap("<leader>f", tele.live_grep, "live grep")
            k.nmap("<leader>ff", tele.find_files, "find files")

            ts.setup {
                pickers = {
                    buffers = {
                        mappings = {
                            i = {
                                ["<C-d>"] = ta.delete_buffer,
                            },
                        },
                    },
                },

                defaults = {
                    dynamic_preview_title = true,
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--trim",
                    },
                },

                extensions = {
                    ["ui-select"] = {
                        require "telescope.themes".get_dropdown {},
                    },

                    ["cmdline"] = {
                        mappings = {
                            complete = "<C-y>",
                            run_selection = "<c-cr>",
                            run_input = "<cr>",
                        },
                    },
                },
            }
        end,
    },

    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build =
        "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    },
}
