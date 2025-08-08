local M = {}

local k, au = require "utils.kmap", require "utils.au"
local tele = require "telescope.builtin"
local cmp = require "cmp_nvim_lsp"
local buf = vim.lsp.buf

local function diag_next()
    vim.diagnostic.jump { count = 1, float = true }
end

local function diag_prev()
    vim.diagnostic.jump { count = -1, float = true }
end

local function on_attach(_, bufnr)
    au.group("Format", function(autocmd)
        autocmd("BufWritePre", {
            callback = function()
                buf.format {
                    bufnr = bufnr,
                    timeout_ms = 200,
                }
            end,
        })
    end)
    local opts = { buffer = bufnr, silent = true }
    local function hover()
        buf.hover { border = "rounded" }
    end

    k.nmap("<C-w>d", vim.diagnostic.open_float, "local diagnostic")
    k.nmap("<leader><leader>", tele.diagnostics, "diagnostics")

    k.nmap("gr", tele.lsp_references, "find references", opts)
    k.nmap("gd", tele.lsp_definitions, "go to definition", opts)
    k.nmap("gi", tele.lsp_implementations, "go to implementation", opts)
    k.nmap("gD", buf.declaration, "go to declaration", opts)
    k.nmap("K", hover, "hover documentation", opts)
    k.nmap("grn", buf.rename, "rename symbol", opts)
    k.nmap("<leader>ca", buf.code_action, "code action", opts)
    k.map({ "n", "v", "i" }, "<C-.>", buf.code_action, "code action", opts)
    k.nmap("<F8>", diag_next, "go to next error")
    k.nmap("<F20>", diag_prev, "go to previous error")
    k.nmap("<F12>", tele.lsp_definitions, "goto definition(s)")
    k.nmap("<F24>", tele.lsp_references, "find all references")
end

local caps = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    cmp.default_capabilities()
)

local base_config = { on_attach = on_attach, caps = caps }
local function setup(name, config)
    config = vim.tbl_extend(
        "force",
        base_config,
        config
    )

    vim.lsp.config(name, config)
    vim.lsp.enable(name)
end

M.on_attach = on_attach
M.default_caps = caps
M.setup = setup

return M
