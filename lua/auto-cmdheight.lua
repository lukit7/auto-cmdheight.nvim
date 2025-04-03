--- @type any
local uv = vim.uv or vim.loop

local CmdheightManager = {
    opts = nil, --- @type AutoCmdheightOpts
    settings = nil,
    nsid = nil,
    active = false,
    in_cmd_line = false,
    key_pressed = false,
    nvim_echo = vim.api.nvim_echo,
    cmd_echo = vim.cmd.echo,
    print = print,
}

function CmdheightManager:override_settings()
    if not self.settings then
        self.settings = {
            ruler = vim.o.ruler,
            showcmd = vim.o.showcmd
        }
        vim.o.ruler = false
        vim.o.showcmd = false
    end
end

function CmdheightManager:restore_settings()
    if self.settings then
        vim.o.ruler = self.settings.ruler
        vim.o.showcmd = self.settings.showcmd
        self.settings = nil
    end
end

function CmdheightManager:subscribe_key()
    if self.opts.remove_on_key then
        vim.on_key(function()
            self:unsubscribe_key()
            self:deactivate()
        end, self.nsid)
    else
        self:deactivate()
    end
end

function CmdheightManager:subscribe_timer()
    if self.opts.duration then
        self.timer = vim.defer_fn(function()
            self:subscribe_key()
        end, math.floor(self.opts.duration * 1000))
    end
end

function CmdheightManager:unsubscribe_key()
    vim.on_key(nil, self.nsid)
end

function CmdheightManager:unsubscribe_timer()
    if self.timer then
        uv.timer_stop(self.timer)
        self.timer = nil
    end
end

function CmdheightManager:deactivate(topline)
    if self.active then
        if not self.in_cmd_line then
            if not topline then
                topline = vim.fn.line("w0")
            end
        end
        self.active = false
        vim.o.cmdheight = self.cmdheight
        self:restore_settings()
        self:unsubscribe_key()
        self:unsubscribe_timer()
        if self.in_cmd_line then
            vim.cmd.redraw()
        else
            self:restore_topline(topline)
        end
    end
end

local CTRL_E = vim.api.nvim_replace_termcodes("<c-e>", true, true, true)
local CTRL_Y = vim.api.nvim_replace_termcodes("<c-y>", true, true, true)

function CmdheightManager:restore_topline(topline)
    local new_topline = vim.fn.line("w0")

    local difference = new_topline - topline
    if difference > 0 then
        vim.api.nvim_feedkeys(math.abs(difference) .. CTRL_Y, "n", false)
    elseif difference < 0 then
        vim.api.nvim_feedkeys(math.abs(difference) .. CTRL_E, "n", false)
    end

end

function CmdheightManager:activate(length)
    if self.in_cmd_line then
        return
    end

    local topline = vim.fn.line("w0")

    self:restore_settings()

    if not self.active then
        self.cmdheight = vim.o.cmdheight
    end

    local echospace = vim.v.echospace
    local columns = vim.o.columns
    local lines = 1 + math.floor((length - 1) / columns)
    local remainder = length % columns
    local override = remainder >= echospace and lines >= self.cmdheight

    if (lines <= self.cmdheight and not override)
        or lines > self.opts.max_lines
    then
        self:deactivate(topline)
        return
    end

    self.active = true

    self:unsubscribe_key()
    self:unsubscribe_timer()
    self:subscribe_timer()

    if override then
        self:override_settings()
    end
    vim.o.cmdheight = math.max(lines, self.cmdheight)
    self:restore_topline(topline)
end

--- @param opts AutoCmdheightOpts
function CmdheightManager:setup(opts)
    self.opts = opts

    self.nsid = vim.api.nvim_create_namespace("auto-cmdheight")
    vim.api.nvim_create_augroup("auto-cmdheight", { clear = true })

    vim.api.nvim_create_autocmd("CmdlineEnter", {
        pattern = "*",
        group = "auto-cmdheight",
        callback = function()
            self.in_cmd_line = true
            self:deactivate()
        end
    })
    vim.api.nvim_create_autocmd("CmdlineLeave", {
        pattern = "*",
        group = "auto-cmdheight",
        callback = function()
            self.in_cmd_line = false
            self:deactivate()
        end
    })
    vim.api.nvim_create_autocmd("VimResized", {
        pattern = "*",
        group = "auto-cmdheight",
        callback = function()
            self:deactivate()
        end
    })

    function _G.print(...)
        local length = 0
        for i = 1, select("#", ...) do
            length = length + #tostring(select(i, ...))
        end
        self:activate(length)
        self.print(...)
    end

    --- @diagnostic disable-next-line
    function vim.api.nvim_echo(chunks, _history, _opts)
        if type(chunks) == "table" then
            local length = 0
            for _, chunk in ipairs(chunks) do
                if type(chunk) == "table" and chunk[1] then
                    length = length + #tostring(chunk[1])
                end
            end
            self:activate(length)
        end
        self.nvim_echo(chunks, _history, _opts)
    end
end

--- @class AutoCmdheightOpts
--- @field max_lines? number
--- @field duration? number
--- @field remove_on_key? boolean

local M = {}

--- @param opts? AutoCmdheightOpts
function M.setup(opts)
    opts = vim.tbl_extend("keep", opts or {}, {
        max_lines = 5,
        duration = 2,
        remove_on_key = true,
    })
    opts.duration = math.max(opts.duration, 0.1)
    CmdheightManager:setup(opts)
end

return M
