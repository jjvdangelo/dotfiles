local M = {}

local m = require "utils.kmap"
local au = require "utils.au"
local cmp = require "cmp_nvim_lsp"
local builtin = require "telescope.builtin"

local buf = vim.lsp.buf

local function wrap(f)
    local opts = { hidden = true, no_ignore = true }
    return function(o)
        o = vim.tbl_deep_extend("force", opts, o or {})
        return f(o)
    end
end

local find_files = wrap(builtin.find_files)
local lsp_definitions = wrap(builtin.lsp_definitions)
local lsp_references = wrap(builtin.lsp_references)
local lsp_declarations = wrap(builtin.lsp_declarations)
local lsp_implementations = wrap(builtin.lsp_implementations)
local live_grep = wrap(builtin.live_grep)

local function hover()
    vim.lsp.buf.hover { border = "rounded" }
end

local function on_attach(_, bufnr)
    au.group("Format", function(autocmd)
        autocmd("BufWritePre", {
            callback = function()
                buf.format { timeout_ms = 200 }
            end,
        })
    end)

    local opts = { buffer = bufnr }
    m.map({ "n", "v" }, "<leader>ca", buf.code_action, "code action", opts)
    m.nmap("gd", lsp_definitions, "goto definition(s)", opts)
    m.nmap("gD", lsp_declarations, "goto declaration(s)", opts)
    m.nmap("gi", lsp_implementations, "goto implementation(s)", opts)
    m.nmap("gr", lsp_references, "find references", opts)
    m.nmap("K", hover, "hover info", opts)
    m.nmap("grn", vim.lsp.buf.rename, "rename", opts)
    m.map({ "n", "i", "v" }, "<C-w>d", vim.diagnostic.open_float, "open float", opts)

    m.nmap("<leader>f", find_files, "find files", opts)
    m.nmap("<leader>fg", live_grep, "live grep", opts)

    -- Visual Studio keybindings
    m.nmap("<F12>", lsp_definitions, "goto definition(s)", opts)
    m.nmap("<F24>", lsp_references, "find all references", opts)
    m.map({ "n", "v", "i" }, "<C-.>", buf.code_action, "code action", opts)
end

local caps = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    cmp.default_capabilities()
)

local default = { capabilities = caps, on_attach = on_attach }
local function wrap_settings(s)
    return vim.tbl_extend("force", default, { settings = s })
end

M.on_attach = on_attach
M.capabilities = caps
M.wrap_settings = wrap_settings

return M
