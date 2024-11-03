---@class snacks.float
---@field id number
---@field buf? number
---@field win? number
---@field opts snacks.float.Config
---@field augroup? number
---@field backdrop? snacks.float
---@overload fun(opts? :snacks.float.Config): snacks.float
local M = setmetatable({}, {
  __call = function(t, ...)
    return t.new(...)
  end,
})

---@class snacks.float.Config
---@field buf? number
---@field file? string
---@field enter? boolean
---@field backdrop? number|false
---@field win? vim.api.keyset.win_config
---@field wo? vim.wo
---@field bo? vim.bo
---@field keys? table<string, false|string|fun(self: snacks.float)>
---@field b? table<string, any>
---@field w? table<string, any>
local defaults = {
  backdrop = 60,
  win = {
    relative = "editor",
    height = 0.9,
    width = 0.9,
    style = "minimal",
    zindex = 50,
  },
  wo = {},
  bo = {
    filetype = "snacks_float",
  },
  keys = {
    q = "close",
  },
}

vim.api.nvim_set_hl(0, "SnackFloatBackdrop", { bg = "#000000", default = true })

local id = 0

---@param opts? snacks.float.Config
---@return snacks.float
function M.new(opts)
  local self = setmetatable({}, { __index = M })
  id = id + 1
  self.id = id
  self.opts = vim.tbl_deep_extend("force", {}, Snacks.config.get("float", defaults), opts or {})
  self:show()
  return self
end

---@param opts? { buf: boolean }
function M:close(opts)
  opts = opts or {}
  local wipe = opts.buf ~= false and not self.opts.buf and not self.opts.file

  local win = self.win
  local buf = wipe and self.buf
  self.win = nil
  if buf then
    self.buf = nil
  end

  vim.schedule(function()
    if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    if buf and vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
    if self.augroup then
      vim.api.nvim_del_augroup_by_id(self.augroup)
      self.augroup = nil
    end
  end)
end

function M:hide()
  self:close({ buf = false })
end

function M:toggle()
  if self:valid() then
    self:hide()
  else
    self:show()
  end
end

function M:show()
  if self:valid() then
    return self
  end
  self.augroup = vim.api.nvim_create_augroup("snacks_float_" .. id, { clear = true })
  if self.buf and vim.api.nvim_buf_is_valid(self.buf) then
    -- keep existing buffer
    self.buf = self.buf
  elseif self.opts.file then
    self.buf = vim.fn.bufadd(self.opts.file)
    if not vim.api.nvim_buf_is_loaded(self.buf) then
      vim.bo[self.buf].readonly = true
      vim.bo[self.buf].swapfile = false
      vim.fn.bufload(self.buf)
      vim.bo[self.buf].modifiable = false
    end
  elseif self.opts.buf then
    self.buf = self.opts.buf
  else
    self.buf = vim.api.nvim_create_buf(false, true)
  end
  if self.opts.bo and vim.bo[self.buf].filetype ~= "" then
    self.opts.bo.filetype = nil
  end
  self:set_options("buf")
  for k, v in pairs(self.opts.b or {}) do
    vim.b[self.buf][k] = v
  end
  self.win = vim.api.nvim_open_win(self.buf, self.opts.enter == nil or self.opts.enter, self:win_opts())
  self:set_options("win")
  for k, v in pairs(self.opts.w or {}) do
    vim.w[self.win][k] = v
  end

  vim.api.nvim_create_autocmd("VimResized", {
    group = self.augroup,
    callback = function()
      if self:valid() then
        vim.api.nvim_win_set_config(self.win, self:win_opts())
      end
    end,
  })

  for key, fn in pairs(self.opts.keys) do
    if fn then
      fn = type(fn) == "string" and self[fn] or fn
      vim.keymap.set("n", key, function()
        fn(self)
      end, { buffer = self.buf })
    end
  end

  self:drop()

  return self
end

function M:drop()
  local has_bg = false
  if vim.fn.has("nvim-0.9.0") == 0 then
    local normal = vim.api.nvim_get_hl_by_name("Normal", true)
    has_bg = normal and normal.background ~= nil
  else
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    has_bg = normal and normal.bg ~= nil
  end

  if has_bg and self.opts.backdrop and self.opts.backdrop < 100 and vim.o.termguicolors then
    self.backdrop = M.new({
      enter = false,
      backdrop = false,
      win = {
        relative = "editor",
        height = 1,
        width = 1,
        style = "minimal",
        focusable = false,
        zindex = self.opts.win.zindex - 1,
      },
      wo = {
        winhighlight = "Normal:SnackFloatBackdrop",
        winblend = self.opts.backdrop,
      },
      bo = {
        buftype = "nofile",
        filetype = "snack_float_backdrop",
      },
    })
    vim.api.nvim_create_autocmd("WinClosed", {
      group = self.augroup,
      pattern = self.win .. "",
      callback = function()
        if self.backdrop then
          self.backdrop:close()
          self.backdrop = nil
        end
      end,
    })
  end
end

function M:win_opts()
  local opts = vim.deepcopy(self.opts.win or {})
  local parent = {
    height = opts.relative == "win" and vim.api.nvim_win_get_height(opts.win) or vim.o.lines,
    width = opts.relative == "win" and vim.api.nvim_win_get_width(opts.win) or vim.o.columns,
  }
  opts.height = math.floor(opts.height <= 1 and parent.height * opts.height or opts.height)
  opts.width = math.floor(opts.width <= 1 and parent.width * opts.width or opts.width)

  opts.row = opts.row or math.floor((parent.height - opts.height) / 2)
  opts.col = opts.col or math.floor((parent.width - opts.width) / 2)
  return opts
end

---@param type "win" | "buf"
function M:set_options(type)
  local opts = type == "win" and self.opts.wo or self.opts.bo
  ---@diagnostic disable-next-line: no-unknown
  for k, v in pairs(opts or {}) do
    ---@diagnostic disable-next-line: no-unknown
    local ok, err = pcall(vim.api.nvim_set_option_value, k, v, type == "win" and {
      scope = "local",
      win = self.win,
    } or { buf = self.buf })
    if not ok then
      vim.notify(
        "Error setting option `" .. k .. "=" .. v .. "`\n\n" .. err,
        vim.log.levels.ERROR,
        { title = "Snacks Float" }
      )
    end
  end
end

function M:buf_valid()
  return self.buf and vim.api.nvim_buf_is_valid(self.buf)
end

function M:win_valid()
  return self.win and vim.api.nvim_win_is_valid(self.win)
end

function M:valid()
  return self:win_valid() and self:buf_valid() and vim.api.nvim_win_get_buf(self.win) == self.buf
end

return M
