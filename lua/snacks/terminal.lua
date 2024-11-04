---@class snacks.terminal
---@overload fun(opts? :snacks.terminal.Config): snacks.float
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
local defaults = {
  float = {
    bo = {
      filetype = "snacks_terminal",
    },
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
  opts = vim.tbl_deep_extend("force", {}, Snacks.config.get("terminal", defaults), opts or {}, {
    float = {
      b = {
        snacks_terminal_cmd = cmd,
      },
    },
  })

  local float = Snacks.float(opts.float)
  vim.api.nvim_buf_call(float.buf, function()
    vim.fn.termopen(cmd or vim.o.shell, vim.tbl_isempty(opts) and vim.empty_dict() or opts)
  end)

  if opts.interactive ~= false then
    vim.cmd.startinsert()
    vim.api.nvim_create_autocmd("TermClose", {
      once = true,
      buffer = float.buf,
      callback = function()
        float:close()
        vim.cmd.checktime()
      end,
    })
    vim.api.nvim_create_autocmd("BufEnter", {
      buffer = float.buf,
      callback = function()
        vim.cmd.startinsert()
      end,
    })
  end
  vim.cmd("noh")
  return float
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
