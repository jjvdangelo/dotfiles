local ts = require "telescope"
local builtin = require "telescope.builtin"
local mgrep = require "core.multi_grep"

ts.setup {
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },

        persisted = {
            layout_config = { width = 0.55, height = 0.55, }
        },
    },
}

ts.load_extension "fzf"

local map = vim.keymap.set
local opts = { noremap = true, silent = false }
map("n", "<leader>f", mgrep.show_finder, opts)
map("n", "<leader>ff", builtin.find_files, opts)
map("n", "<C-p>", builtin.git_files, opts)
map("n", "<leader>ps", function()
    builtin.grep_string { search = vim.fn.input("Grep > ") };
end, opts)
