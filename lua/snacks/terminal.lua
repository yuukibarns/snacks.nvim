---@class snacks.terminal: snacks.float
---@field cmd? string | string[]
---@field opts snacks.terminal.Config
---@overload fun(cmd?: string|string[], opts?: snacks.terminal.Config): snacks.terminal
local M = setmetatable({}, {
  __call = function(t, ...)
    return t.toggle(...)
  end,
})

---@class snacks.terminal.Config
---@field cwd? string
---@field env? table<string, string>
---@field float? snacks.float.Config
---@field interactive? boolean
---@field override? fun(cmd?: string|string[], opts?: snacks.terminal.Config) Use this to use a different terminal implementation
local defaults = {
  float = {
    bo = {
      filetype = "snacks_terminal",
    },
    wo = {},
    keys = {
      gf = function(self)
        local f = vim.fn.findfile(vim.fn.expand("<cfile>"))
        if f ~= "" then
          vim.cmd("close")
          vim.cmd("e " .. f)
        end
      end,
      term_normal = {
        "<esc>",
        function(self)
          self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
          if self.esc_timer:is_active() then
            self.esc_timer:stop()
            vim.cmd("stopinsert")
          else
            self.esc_timer:start(200, 0, function() end)
            return "<esc>"
          end
        end,
        mode = "t",
        expr = true,
        desc = "Double escape to normal mode",
      },
    },
  },
}

---@type table<string, snacks.float>
local terminals = {}

---@param cmd? string | string[]
---@param opts? snacks.terminal.Config
function M.open(cmd, opts)
  ---@type snacks.terminal.Config
  opts = Snacks.config.get("terminal", defaults, opts)
  opts.float.position = opts.float.position or (cmd and "float" or "bottom")
  opts.float.wo.winbar = opts.float.wo.winbar
    or (opts.float.position == "float" and "" or (vim.v.count1 .. ": %{b:term_title}"))

  if opts.override then
    return opts.override(cmd, opts)
  end

  local on_buf = opts.float and opts.float.on_buf

  ---@param self snacks.terminal
  opts.float.on_buf = function(self)
    self.cmd = cmd
    vim.b[self.buf].snacks_terminal_cmd = cmd
    if on_buf then
      on_buf(self)
    end
  end

  local terminal = Snacks.float(opts.float)

  vim.api.nvim_buf_call(terminal.buf, function()
    local term_opts = {
      cwd = opts.cwd,
      env = opts.env,
    }
    vim.fn.termopen(cmd or vim.o.shell, vim.tbl_isempty(term_opts) and vim.empty_dict() or term_opts)
  end)

  if opts.interactive ~= false then
    vim.cmd.startinsert()
    vim.api.nvim_create_autocmd("TermClose", {
      once = true,
      buffer = terminal.buf,
      callback = function()
        terminal:close()
        vim.cmd.checktime()
      end,
    })
    vim.api.nvim_create_autocmd("BufEnter", {
      buffer = terminal.buf,
      callback = function()
        vim.cmd.startinsert()
      end,
    })
  end
  vim.cmd("noh")
  return terminal
end

---@param cmd? string | string[]
---@param opts? snacks.terminal.Config
function M.toggle(cmd, opts)
  ---@type snacks.terminal.Config
  opts = vim.tbl_deep_extend("force", {}, defaults, opts or {})

  local id = vim.inspect({ cmd = cmd, cwd = opts.cwd, env = opts.env, count = vim.v.count1 })

  if terminals[id] and terminals[id]:buf_valid() then
    terminals[id]:toggle()
  else
    terminals[id] = M.open(cmd, opts)
  end
  return terminals[id]
end

return M
