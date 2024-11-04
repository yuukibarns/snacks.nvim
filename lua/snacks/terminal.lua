---@class snacks.terminal: snacks.win
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
---@field win? snacks.win.Config
---@field interactive? boolean
---@field override? fun(cmd?: string|string[], opts?: snacks.terminal.Config) Use this to use a different terminal implementation
local defaults = {
  win = {
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

---@type table<string, snacks.win>
local terminals = {}

---@param cmd? string | string[]
---@param opts? snacks.terminal.Config
function M.open(cmd, opts)
  local id = vim.v.count1
  ---@type snacks.terminal.Config
  opts = Snacks.config.get("terminal", defaults, { win = Snacks.win.resolve(opts and opts.win) }, opts)
  opts.win.position = opts.win.position or (cmd and "float" or "bottom")
  opts.win.wo.winbar = opts.win.wo.winbar or (opts.win.position == "float" and "" or (id .. ": %{b:term_title}"))

  if opts.override then
    return opts.override(cmd, opts)
  end

  local on_buf = opts.win and opts.win.on_buf

  ---@param self snacks.terminal
  opts.win.on_buf = function(self)
    self.cmd = cmd
    vim.b[self.buf].snacks_terminal = { cmd = cmd, id = id }
    if on_buf then
      on_buf(self)
    end
  end

  local terminal = Snacks.win(opts.win)

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
  opts = opts or {}

  local id = vim.inspect({ cmd = cmd, cwd = opts.cwd, env = opts.env, count = vim.v.count1 })

  if terminals[id] and terminals[id]:buf_valid() then
    terminals[id]:toggle()
  else
    terminals[id] = M.open(cmd, opts)
  end
  return terminals[id]
end

return M
