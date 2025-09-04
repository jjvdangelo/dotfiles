return {
    "jjvdangelo/canvas.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require "canvas".setup { variant = "dark" }
        vim.cmd.colorscheme "canvas"
    end
}
