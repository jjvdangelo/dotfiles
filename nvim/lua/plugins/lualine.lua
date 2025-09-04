return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
            { "stevearc/overseer.nvim" },
        },

        opts = {
            options = {
                theme = "alabaster",
                globalstatus = true,
                icons_enabled = true,
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
            },

            sections = {
                lualine_a = {
                    {
                        "mode",
                        upper = true,
                        fmt = function(str)
                            local map = {
                                NORMAL = "NORM",
                                INSERT = "INS",
                                VISUAL = "VIS",
                                ["V-LINE"] = "V-LINE",
                                ["V-BLOCK"] = "V-BLOCK",
                                REPLACE = "REP",
                                COMMAND = "CMD",
                            }

                            return map[str] or str
                        end,
                    },
                },
                lualine_b = {
                    {
                        "fileformat",
                        symbols = { unix = "", dos = "", mac = "" },
                    },
                    {
                        "encoding",
                        show_bomb = true,
                    },
                    {
                        "branch",
                        icon = "",
                    },
                },
                lualine_c = {
                    {
                        "filename",
                        file_status = true,
                        newfile_status = true,
                        path = 1,
                        shorting_target = 40,
                        symbols = {
                            modified = "󱇧",
                            readonly = "󰈡",
                            unnamed = "",
                            newfile = "󰝒",
                        },
                    },
                },
                lualine_x = {
                    {
                        "lsp_status",
                        icon = "",
                        symbols = {
                            spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
                            done = "",
                            separator = " ",
                        }
                    },
                },
                lualine_y = {
                    {
                        "overseer",
                        colored = true,
                        unique = false,
                        name = nil,
                        name_not = false,
                        status = nil,
                        status_not = false,
                    },
                    {
                        "filetype",
                        colored = true,
                        icon_only = false,
                        icon = { align = "right" },
                    },
                    {
                        "progress"
                    },
                    {
                        "diff",
                        colored = true,
                        symbols = {
                            added = " ",
                            modified = " ",
                            removed = " ",
                            renamed = " ",
                        },
                    },
                },
                lualine_z = {
                    "location",
                },
            },
        },
    }
}
