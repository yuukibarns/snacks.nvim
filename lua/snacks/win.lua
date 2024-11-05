---@class snacks.win
---@field id number
---@field buf? number
---@field win? number
---@field opts snacks.win.Config
---@field augroup? number
---@field backdrop? snacks.win
---@overload fun(opts? :snacks.win.Config): snacks.win
local M = setmetatable({}, {
  __call = function(t, ...)
    return t.new(...)
  end,
})

---@class snacks.win.Keys: vim.api.keyset.keymap
---@field [1]? string
---@field [2]? string|fun(self: snacks.win): any
---@field mode? string|string[]

---@class snacks.win.Config
---@field view? string merges with config from `Snacks.config.views[view]`
---@field position? "float"|"bottom"|"top"|"left"|"right"
---@field buf? number
---@field file? string
---@field enter? boolean
---@field backdrop? number|false
---@field win? vim.api.keyset.win_config
---@field wo? vim.wo
---@field bo? vim.bo
---@field keys? table<string, false|string|fun(self: snacks.win)|snacks.win.Keys>
---@field on_buf? fun(self: snacks.win)
---@field on_win? fun(self: snacks.win)
local defaults = {
  position = "float",
  win = {
    relative = "editor",
    style = "minimal",
  },
  wo = {
    winhighlight = "Normal:NormalFloat,NormalNC:NormalFloat",
  },
  bo = {},
  keys = {
    q = "close",
  },
}

---@type snacks.win.Config
local defaults_float = {
  backdrop = 60,
  win = {
    height = 0.9,
    width = 0.9,
    zindex = 50,
  },
}

---@type snacks.win.Config
local defaults_split = {
  win = {
    height = 0.4,
    width = 0.4,
  },
}

local split_commands = {
  editor = {
    top = "topleft",
    right = "vertical botright",
    bottom = "botright",
    left = "vertical topleft",
  },
  win = {
    top = "aboveleft",
    right = "vertical rightbelow",
    bottom = "belowright",
    left = "vertical leftabove",
  },
}

---@type snacks.win.Config
local minimal = {
  wo = {
    cursorcolumn = false,
    cursorline = true,
    cursorlineopt = "both",
    fillchars = "eob: ",
    list = false,
    number = false,
    relativenumber = false,
    signcolumn = "no",
    spell = false,
    winbar = "",
    statuscolumn = "",
    winfixheight = true,
    winfixwidth = true,
    wrap = false,
  },
}

vim.api.nvim_set_hl(0, "SnackFloatBackdrop", { bg = "#000000", default = true })

local id = 0

---@param opts? snacks.win.Config
---@return snacks.win.Config
function M.resolve(opts)
  opts = opts or {}
  local done = {} ---@type string[]
  local views = { opts } ---@type snacks.win.Config[]
  local view = opts.view
  while view and not vim.tbl_contains(done, view) do
    table.insert(done, view)
    if not Snacks.config.views[view] then
      break
    end
    table.insert(views, 1, Snacks.config.views[view])
    view = Snacks.config.views[view].view
  end
  local ret = #views == 0 and {} or #views == 1 and views[1] or vim.tbl_deep_extend("force", {}, unpack(views))
  ret.view = nil
  return ret
end

---@param opts? snacks.win.Config
---@return snacks.win
function M.new(opts)
  local self = setmetatable({}, { __index = M })
  id = id + 1
  self.id = id
  opts = Snacks.config.get("win", defaults, M.resolve(opts))
  opts =
    vim.tbl_deep_extend("force", {}, vim.deepcopy(opts.position == "float" and defaults_float or defaults_split), opts)
  if opts.win.style == "minimal" then
    opts = vim.tbl_deep_extend("force", {}, vim.deepcopy(minimal), opts)
  end
  self.opts = opts
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
      pcall(vim.api.nvim_del_augroup_by_id, self.augroup)
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

---@private
function M:open_buf()
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
  if vim.bo[self.buf].filetype == "" and not self.opts.bo.filetype then
    self.opts.bo.filetype = "snacks_float"
  end
end

---@private
function M:open_win()
  local relative = self.opts.win.relative or "editor"
  local position = self.opts.position or "float"
  local enter = self.opts.enter == nil or self.opts.enter or false
  local opts = self:win_opts()
  if position == "float" then
    self.win = vim.api.nvim_open_win(self.buf, enter, opts)
  else
    local parent = self.opts.win.win or 0
    local vertical = position == "left" or position == "right"
    if parent == 0 then
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if
          vim.w[win].snacks_float
          and vim.w[win].snacks_float.relative == "editor"
          and vim.w[win].snacks_float.position == position
        then
          parent = win
          relative = "win"
          position = vertical and "bottom" or "right"
          vertical = not vertical
          break
        end
      end
    end
    local cmd = split_commands[relative][position]
    local size = vertical and opts.width or opts.height
    vim.api.nvim_win_call(parent, function()
      vim.cmd("silent noswapfile " .. cmd .. " " .. size .. "split")
      vim.api.nvim_win_set_buf(0, self.buf)
      self.win = vim.api.nvim_get_current_win()
    end)
    if enter then
      vim.api.nvim_set_current_win(self.win)
    end
  end
  vim.w[self.win].snacks_float = {
    id = self.id,
    position = self.opts.position,
    relative = self.opts.win.relative,
  }
end

function M:show()
  if self:valid() then
    return self
  end
  self.augroup = vim.api.nvim_create_augroup("snacks_float_" .. id, { clear = true })

  self:open_buf()
  self:set_options("buf")
  if self.opts.on_buf then
    self.opts.on_buf(self)
  end

  self:open_win()
  self:set_options("win")
  if self.opts.on_win then
    self.opts.on_win(self)
  end

  local ft = vim.bo[self.buf].filetype
  local lang = ft and vim.treesitter.language.get_lang(ft)
  if lang and not vim.b[self.buf].ts_highlight and not pcall(vim.treesitter.start, self.buf, lang) and ft then
    vim.bo[self.buf].syntax = ft
  end

  vim.api.nvim_create_autocmd("VimResized", {
    group = self.augroup,
    callback = function()
      if self:valid() then
        vim.api.nvim_win_set_config(self.win, self:win_opts())
      end
    end,
  })

  for key, spec in pairs(self.opts.keys) do
    if spec then
      if type(spec) == "string" then
        spec = { key, self[spec] and self[spec] or spec, desc = spec }
      elseif type(spec) == "function" then
        spec = { key, spec }
      end
      local opts = vim.deepcopy(spec)
      opts[1] = nil
      opts[2] = nil
      opts.mode = nil
      opts.buffer = self.buf
      local rhs = spec[2]
      if type(rhs) == "function" then
        rhs = function()
          return spec[2](self)
        end
      end
      ---@cast spec snacks.win.Keys
      vim.keymap.set(spec.mode or "n", spec[1], rhs, opts)
    end
  end

  self:drop()

  return self
end

function M:is_floating()
  return self:valid() and vim.api.nvim_win_get_config(self.win).zindex ~= nil
end

---@private
function M:drop()
  -- don't show a backdrop for non-floating windows
  if not self:is_floating() then
    return
  end
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

---@private
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

---@private
---@param type "win" | "buf"
function M:set_options(type)
  local ei = vim.o.eventignore
  vim.o.eventignore = "all"
  local opts = type == "win" and self.opts.wo or self.opts.bo
  ---@diagnostic disable-next-line: no-unknown
  for k, v in pairs(opts or {}) do
    ---@diagnostic disable-next-line: no-unknown
    local ok, err = pcall(vim.api.nvim_set_option_value, k, v, type == "win" and {
      scope = "local",
      win = self.win,
    } or { buf = self.buf })
    if not ok then
      Snacks.notify.error("Error setting option `" .. k .. "=" .. v .. "`\n\n" .. err, { title = "Snacks Float" })
    end
  end
  vim.o.eventignore = ei
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
