local M = {}

local util = require "lspconfig.util"
local log = require "lsp.log"

local cache = { loaded = false, configs = {}, map = {} }

local function load_all()
    if cache.loaded then
        return
    end

    log.info("loading all configs")

    local dir = vim.fn.stdpath("config") .. "/after/lsp"
    local files = vim.fn.globpath(dir, "*.lua", false, true)
    log.debug("scan dir", dir)
    log.debug("found files", files)

    for _, f in ipairs(files) do
        local ok, cfg = pcall(dofile, f)
        if not ok then
            log.warn("dofile error for", f, cfg)
        elseif type(cfg) ~= "table" or not cfg.name then
            log.debug("ignored (not table or missing name):", f)
        else
            cache.configs[cfg.name] = cfg
            log.info("loaded", cfg.name, "filetypes=", cfg.filetypes)

            if type(cfg.filetypes) == "table" then
                for _, ft in ipairs(cfg.filetypes) do
                    cache.map[ft] = cache.map[ft] or {}
                    table.insert(cache.map[ft], cfg.name)
                end
            end
        end
    end

    cache.loaded = true
end

local function resolve_root(cfg, name)
    local rd = cfg.root_dir
    if type(rd) == "function" then
        rd = rd(fname)
    end

    if type(rd) == "string" and rd ~= "" then
        return rd
    end

    local rp = cfg.root_patterns
    if type(rp) == "table" then
        for _, item in ipairs(rp) do
            local found = util.root_pattern(item)(fname)
            if found then
                return found
            end
        end
    end

    return util.path.dirname(fname)
end

function M.start()
    load_all()

    local ft = vim.bo.filetype
    local fname = vim.api.nvim_buf_get_name(0)
    local list = cache.map[ft] or {}
    log.debug("start ft=", ft, "buf=", fname, "servers=", list)

    for _, name in ipairs(list) do
        local cfg = vim.deepcopy(cache.configs[name])
        if not cfg then
            log.warn("no cfg for", name)
            goto continue
        end

        local root = resolve_root(cfg, fname)
        cfg.root_dir = root
        cfg.cmd_cwd = cfg.cmd_cwd or root

        local exists = false
        for _, c in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
            if c.name == name and c.config.root_dir == root then
                exists = true
                break
            end
        end

        if exists then
            log.debug(name, "already running for", root)
        else
            log.info("starting", name, "root=", root, "cmd=", cfg.cmd)
            vim.lsp.start(cfg)
        end
        ::continue::
    end
end

return M
