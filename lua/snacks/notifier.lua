---@class snacks.notifier
---@field queue snacks.notifier.Notif[]
---@field opts snacks.notifier.Config
---@field dirty boolean
local M = {}

Snacks.config.view("notification", {
  win = {
    border = "rounded",
    zindex = 100,
  },
  wo = {
    winblend = 5,
    wrap = false,
  },
})

M.ns = vim.api.nvim_create_namespace("snacks.notifier")

---@alias snacks.notifier.hl "title"|"icon"|"border"|"footer"|"msg"

---@class snacks.notifier.ctx
---@field opts snacks.win.Config
---@field notifier snacks.notifier
---@field hl table<snacks.notifier.hl, string>
---@field ns number

---@alias snacks.notifier.render fun(buf: number, notif: snacks.notifier.Notif, ctx: snacks.notifier.ctx)

--- Render styles:
--- * compact: simple border title with message
--- * fancy: similar to the default nvim-notify style
---@alias snacks.notifier.style snacks.notifier.render|"compact"|"fancy"

---@type table<string, snacks.notifier.render>
M.styles = {
  -- compact style using border title
  compact = function(buf, notif, ctx)
    ctx.opts.win.title = {
      { " " .. vim.trim(notif.icon .. " " .. (notif.title or "")) .. " ", ctx.hl.title },
    }
    ctx.opts.win.title_pos = "center"
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(notif.msg, "\n"))
  end,
  -- similar to the default nvim-notify style
  fancy = function(buf, notif, ctx)
    vim.api.nvim_buf_set_lines(buf, 0, 1, false, { "", "" })
    vim.api.nvim_buf_set_lines(buf, 2, -1, false, vim.split(notif.msg, "\n"))
    vim.api.nvim_buf_set_extmark(buf, ctx.ns, 0, 0, {
      virt_text = { { " " }, { notif.icon, ctx.hl.icon }, { " " }, { notif.title or "", ctx.hl.title } },
      virt_text_win_col = 0,
      priority = 10,
    })
    vim.api.nvim_buf_set_extmark(buf, ctx.ns, 0, 0, {
      virt_text = { { " " }, { os.date("%X", notif.added), ctx.hl.title }, { " " } },
      virt_text_pos = "right_align",
      priority = 10,
    })
    vim.api.nvim_buf_set_extmark(buf, ctx.ns, 1, 0, {
      virt_text = { { string.rep("━", vim.o.columns - 2), ctx.hl.border } },
      virt_text_win_col = 0,
      priority = 10,
    })
  end,
}

---@class snacks.notifier.Config
---@field keep? fun(notif: snacks.notifier.Notif): boolean
local defaults = {
  timeout = 3000,
  width = { min = 40, max = 0.4 },
  height = { min = 1, max = 0.6 },
  padding = false, -- add 1 cell of left/right padding to the notification window
  sort = { "level", "added" }, -- sort by level and time
  icons = {
    error = " ",
    warn = " ",
    info = " ",
    debug = " ",
    trace = " ",
  },
  ---@type snacks.notifier.style
  style = "compact",
}

---@alias snacks.notifier.level "trace"|"debug"|"info"|"warn"|"error"
---@type table<number, snacks.notifier.level>
M.levels = {
  [vim.log.levels.TRACE] = "trace",
  [vim.log.levels.DEBUG] = "debug",
  [vim.log.levels.INFO] = "info",
  [vim.log.levels.WARN] = "warn",
  [vim.log.levels.ERROR] = "error",
}
M.level_names = vim.tbl_values(M.levels) ---@type snacks.notifier.level[]

---@param level number|string
---@return snacks.notifier.level
local function normlevel(level)
  return type(level) == "string" and (vim.tbl_contains(M.level_names, level:lower()) and level:lower() or "info")
    or M.levels[level]
    or "info"
end

---@param name string
---@param level? snacks.notifier.level
local function hl(name, level)
  return "SnacksNotifier" .. name .. (level and (level:sub(1, 1):upper() .. level:sub(2):lower()) or "")
end

---@class snacks.notifier.Notif.opts
---@field id? number|string
---@field msg? string
---@field level? number|snacks.notifier.level
---@field title? string
---@field icon? string
---@field timeout? number
---@field once? boolean
---@field ft? string
---@field keep? fun(notif: snacks.notifier.Notif): boolean
---@field style? snacks.notifier.style

---@class snacks.notifier.Notif: snacks.notifier.Notif.opts
---@field msg string
---@field id number|string
---@field win? snacks.win
---@field icon string
---@field level snacks.notifier.level
---@field timeout number
---@field dirty? boolean
---@field shown? number timestamp in ms
---@field added number timestamp in ms
---@field layout? { width: number, height: number, top?: number }

local _id = 0

local function next_id()
  _id = _id + 1
  return _id
end

---@param opts? snacks.notifier.Config
---@return snacks.notifier
function M.new(opts)
  local self = setmetatable({}, { __index = M })
  self.opts = Snacks.config.get("notifier", defaults, opts)
  self.queue = {}
  self.dirty = false
  self:init()
  self:start()
  return self
end

function M:init()
  local links = {} ---@type table<string, string>
  for _, level in ipairs(M.level_names) do
    local cap = level:sub(1, 1):upper() .. level:sub(2):lower()
    cap = (cap == "Trace" or cap == "Debug") and "Hint" or cap
    links[hl("", level)] = "Normal"
    links[hl("Icon", level)] = "DiagnosticSign" .. cap
    links[hl("Border", level)] = "Diagnostic" .. cap
    links[hl("Title", level)] = "Diagnostic" .. cap
    links[hl("Footer", level)] = "Diagnostic" .. cap
  end
  for k, v in pairs(links) do
    vim.api.nvim_set_hl(0, k, { link = v, default = true })
  end
end

function M:start()
  vim.uv.new_timer():start(
    100,
    100,
    vim.schedule_wrap(function()
      if #self.queue == 0 then
        return
      end
      local ok, err = pcall(function()
        self:update()
        self:layout()
      end)
      if not ok then
        vim.api.nvim_err_writeln("Snacks notifier failed. Dropping queue. Error:\n " .. err)
        self.queue = {}
      end
    end)
  )
end

---@param opts snacks.notifier.Notif.opts
function M:add(opts)
  local now = vim.uv.hrtime() / 1e6
  local notif = vim.deepcopy(opts) --[[@as snacks.notifier.Notif]]
  notif.msg = notif.msg or ""
  notif.id = notif.id or next_id()
  notif.level = normlevel(notif.level)
  notif.icon = notif.icon or self.opts.icons[notif.level]
  notif.timeout = notif.timeout or self.opts.timeout
  notif.added = os.time()
  if opts.id then
    for i, n in ipairs(self.queue) do
      if n.id == notif.id then
        notif.shown = n.shown and now or nil -- reset shown time
        notif.win = n.win
        notif.layout = n.layout
        notif.dirty = true
        self.queue[i] = notif
        return notif.id
      end
    end
  end
  table.insert(self.queue, notif)
  self.dirty = true
  return notif.id
end

---@param msg string
---@param level? snacks.notifier.level|number
---@param opts? snacks.notifier.Notif.opts
function M:notify(msg, level, opts)
  opts = opts or {}
  opts.msg = msg
  opts.level = level
  return self:add(opts)
end

function M:update()
  local now = vim.uv.now()
  --- Cleanup queue
  ---@param notif snacks.notifier.Notif
  self.queue = vim.tbl_filter(function(notif)
    local timeout = notif.timeout or self.opts.timeout
    local keep = not notif.shown -- not shown yet
      or (notif.win and notif.win:win_valid() and vim.api.nvim_get_current_win() == notif.win.win) -- current window
      or (notif.keep and notif.keep(notif)) -- custom keep
      or (self.opts.keep and self.opts.keep(notif)) -- global keep
      or (notif.shown + timeout > now) -- not timed out
    if not keep and notif.win then
      notif.win:close()
      notif.win = nil
      self.dirty = true
    end
    return keep
  end, self.queue)
  if self.dirty then
    self:sort()
  end
  self.dirty = false
end

---@param id? number|string
function M:hide(id)
  ---@param notif snacks.notifier.Notif
  self.queue = vim.tbl_filter(function(notif)
    if notif.win and id == nil or notif.id == id then
      notif.win:close()
      return false
    end
    return true
  end, self.queue)
end

---@param value number
---@param min number
---@param max number
---@param parent number
local function dim(value, min, max, parent)
  min = math.floor(min < 1 and (parent * min) or min)
  max = math.floor(max < 1 and (parent * max) or max)
  return math.min(max, math.max(min, value))
end

---@param style? snacks.notifier.style
---@return snacks.notifier.render
function M:get_render(style)
  style = style or self.opts.style
  return type(style) == "function" and style or M.styles[style] or M.styles.compact
end

---@param notif snacks.notifier.Notif
function M:render(notif)
  local win = notif.win
    or Snacks.win({
      show = false,
      view = "notification",
      enter = false,
      backdrop = false,
      bo = { filetype = notif.ft or "markdown", modifiable = false },
      win = { noautocmd = true },
      wo = {
        winhighlight = table.concat({
          "Normal:" .. hl("", notif.level),
          "NormalNC:" .. hl("", notif.level),
          "FloatBorder:" .. hl("Border", notif.level),
          "FloatTitle:" .. hl("Title", notif.level),
          "FloatFooter:" .. hl("Footer", notif.level),
        }, ","),
      },
      keys = {
        q = function()
          self:hide(notif.id)
        end,
      },
    })
  notif.win = win
  local buf = win:open_buf()
  vim.api.nvim_buf_clear_namespace(buf, M.ns, 0, -1)
  local render = self:get_render(notif.style)

  local ctx = {
    opts = win.opts,
    notifier = self,
    ns = M.ns,
    hl = {
      title = hl("Title", notif.level),
      icon = hl("Icon", notif.level),
      border = hl("Border", notif.level),
      footer = hl("Footer", notif.level),
      msg = hl("", notif.level),
    },
  }
  render(buf, notif, ctx)

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  local pad = self.opts.padding and (win:add_padding() or 2) or 0
  local width = 0
  for _, line in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(line) + pad)
  end
  width = dim(width, self.opts.width.min, self.opts.width.max, vim.o.columns)

  local height = #lines
  -- calculate wrapped height
  if win.opts.wo.wrap then
    height = 0
    for _, line in ipairs(lines) do
      height = height + math.ceil((vim.fn.strdisplaywidth(line) + pad) / width)
    end
  end
  height = dim(height, self.opts.height.min, self.opts.height.max, vim.o.lines)

  win.opts.win.width = width
  win.opts.win.height = height
end

function M:sort()
  local idx = {} ---@type table<snacks.notifier.Notif, number>
  for i, notif in ipairs(self.queue) do
    idx[notif] = i
  end
  table.sort(self.queue, function(a, b)
    for _, key in ipairs(self.opts.sort) do
      local function v(n)
        return key == "level" and (10 - vim.log.levels[n[key]:upper()]) or key == "added" and idx[n] or n[key]
      end
      local av, bv = v(a), v(b)
      if av ~= bv then
        return av < bv
      end
    end
    return false
  end)
end

function M:layout()
  local free = {} ---@type boolean[]
  for i = 1, vim.o.lines do
    free[i] = true
  end
  local function mark(row, height)
    for i = row, row + height - 1 do
      free[i] = false
    end
  end
  local function find(height, row)
    for i = row or 1, vim.o.lines - height do
      local ret = true
      for j = i, i + height - 1 do
        if not free[j] then
          ret = false
          break
        end
      end
      if ret then
        return i
      end
    end
  end
  local shown = 0
  local max_visible = vim.o.lines * (self.opts.height.min + 2)
  for _, notif in ipairs(self.queue) do
    local skip = shown >= max_visible
    if not skip then
      if not notif.win or notif.dirty or not notif.win:buf_valid() then
        notif.dirty = false
        self:render(notif)
        notif.layout = notif.win:size()
      end
      notif.layout.top = find(notif.layout.height, notif.layout.top)
    end
    if not skip and notif.layout.top then
      shown = shown + 1
      mark(notif.layout.top, notif.layout.height)
      notif.win.opts.win.row = notif.layout.top
      notif.win.opts.win.col = vim.o.columns - notif.layout.width - 1
      notif.shown = notif.shown or vim.uv.now()
      notif.win:show()
      notif.win:update()
    elseif notif.win then
      notif.shown = nil
      notif.win:hide()
    end
  end
  vim.cmd.redraw()
end

-- Single instance
return M.new()
