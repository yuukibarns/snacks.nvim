---@class snacks.image.inline
---@field buf number
---@field managed table<string, snacks.image.match>  -- key: range string (srow,scol,erow,ecol)
---@field placements table<string, snacks.image.Placement> -- key: same as managed
local M = {}
M.__index = M

---@param src string
local function convert(src)
  local _convert = Snacks.image.convert.convert({ src = src })
  return _convert.file
end

-- Generate key from image range
---@param img snacks.image.match
---@return string
local function get_key(img)
  return table.concat(img.range, ',')
end

---@param key string range key in format "srow,scol,erow,ecol"
---@return Range4
local function key_to_range(key)
  local parts = vim.split(key, ',', { plain = true })
  return {
    tonumber(parts[1]),
    tonumber(parts[2]),
    tonumber(parts[3]),
    tonumber(parts[4]),
  }
end

-- Check if cursor is within image range
---@param cursor integer[] [row, col] (1-indexed, col 0-indexed)
---@param range Range4 [srow, scol, erow, ecol] (0-indexed)
---@return boolean
local function is_cursor_in_range(cursor, range)
  if
      (range[1] == range[3] and cursor[2] >= range[2] and cursor[2] <= range[4])
      or (range[1] ~= range[3] and cursor[1] >= range[1] and cursor[1] <= range[3])
  then
    return true
  end
  return false
end

function M.new(buf)
  local self = setmetatable({}, M)
  self.buf = buf
  self.managed = {}
  self.placements = {}

  local group = vim.api.nvim_create_augroup("snacks.image.inline." .. buf, { clear = true })
  local update = Snacks.util.debounce(function() self:update() end, { ms = 200 })

  vim.api.nvim_create_autocmd({ "BufWritePost", "WinScrolled" }, {
    group = group,
    buffer = buf,
    callback = vim.schedule_wrap(update),
  })

  vim.api.nvim_create_autocmd({ "ModeChanged", "CursorMoved" }, {
    group = group,
    buffer = buf,
    callback = function(ev)
      if ev.buf == self.buf and ev.buf == vim.api.nvim_get_current_buf() then
        self:conceal()
      end
    end,
  })

  vim.schedule(update)
  return self
end

function M:conceal()
  local mode = vim.fn.mode():sub(1, 1):lower()
  -- for _, placement in pairs(self.placements) do
  --   placement:show()
  -- end

  if vim.wo.concealcursor:find(mode) then
    return
  end

  local from, to = vim.fn.line("v"), vim.fn.line(".")
  from, to = math.min(from, to), math.max(from, to)

  -- Hide placements in visual selection
  for key, placement in pairs(self.placements) do
    local range = key_to_range(key)
    -- Check if image range overlaps with visual selection
    local srow, erow = range[1], range[3]  -- convert to 1-indexed
    if (srow >= from and srow <= to) or    -- start line in selection
        (erow >= from and erow <= to) or   -- end line in selection
        (srow <= from and erow >= to) then -- selection spans image
      if placement.opts.conceal then
        placement:hide()
      else
        placement:show()
      end
    else
      -- if placement.type == "math" and not placement.opts.conceal then
      --   placement.opts.conceal = true
      -- end
      placement:show()
    end
  end
end

function M:update()
  local conceal = Snacks.image.config.doc.conceal
  conceal = type(conceal) ~= "function" and function() return conceal end or conceal

  local wins = vim.fn.win_findbuf(self.buf)
  local visible_windows = {} ---@type {topline: integer, botline: integer}[]
  local visible_matches = {} ---@type table<string, snacks.image.match>
  local visible_managed = {} ---@type table<string, snacks.image.match>

  for _, winid in ipairs(wins) do
    local info = vim.fn.getwininfo(winid)[1]
    visible_windows[#visible_windows + 1] = { topline = info.topline, botline = info.botline }
  end

  for _, win in ipairs(visible_windows) do
    Snacks.image.doc.find(self.buf, function(matches)
      for _, img in ipairs(matches) do
        local key = get_key(img)
        visible_matches[key] = img
      end
    end, { from = win.topline, to = win.botline })
  end

  -- Determine visible *unchanged* managed images and delete the others
  for key, img in pairs(self.managed) do
    local is_changed = false
    if visible_matches[key] then
      if img.content == visible_matches[key].content then
        visible_managed[key] = img
      else
        is_changed = true
        self.managed[key] = nil
        if self.placements[key] then
          self.placements[key]:close()
          self.placements[key] = nil
        end
      end
    else
      for _, win in ipairs(visible_windows) do
        if img.range and img.range[1] + 1 >= win.topline and img.range[1] + 1 <= win.botline then
          self.managed[key] = nil
          if self.placements[key] then
            self.placements[key]:close()
            self.placements[key] = nil
          end
          is_changed = true
          break
        end
      end
      if not is_changed then
        if self.placements[key] then
          self.placements[key]:close()
          self.placements[key] = nil
        end
      end
    end
  end

  -- Create/update visible placements
  for key, img in pairs(visible_managed) do
    local placement = self.placements[key]
    if not placement then
      self.placements[key] = Snacks.image.placement.new(
        self.buf,
        img.src,
        Snacks.config.merge({}, Snacks.image.config.doc, {
          pos = img.pos,
          range = img.range,
          inline = true,
          conceal = conceal(img.lang, img.type),
          type = img.type,
        })
      )
    else
      placement.opts.pos = img.pos
      placement.opts.range = img.range
      placement:update()
    end
  end
end

---Open image at cursor position
function M:open()
  local mode = vim.fn.mode():sub(1, 1):lower()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local from, to = vim.fn.line("v"), vim.fn.line(".")
  from, to = math.min(from, to), math.max(from, to)

  if mode == "n" then
    Snacks.image.doc.find(vim.api.nvim_get_current_buf(), function(matches)
      for _, img in ipairs(matches) do
        if is_cursor_in_range(cursor, img.range) then
          if img.src then
            local file = convert(img.src)
            vim.fn.setreg("+", file)
            vim.fn.setreg("*", file)
            vim.api.nvim_echo({ { file .. " " .. "copied to clipboard" } }, true, {})
          end
          local key = get_key(img)
          if not self.managed[key] then
            self.managed[key] = img
            self:update()
          end
          self.placements[key].opts.conceal = true
          return
        end
      end
    end, { from = from, to = to })
  else
    Snacks.image.doc.find(vim.api.nvim_get_current_buf(), function(matches)
      for _, img in ipairs(matches) do
        local key = get_key(img)
        if not self.managed[key] then
          self.managed[key] = img
          self:update()
        end
        self.placements[key].opts.conceal = true
      end
      self:update()
    end, { from = from, to = to })
  end
end

---Close image at cursor position
function M:close()
  local mode = vim.fn.mode():sub(1, 1):lower()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local from, to = vim.fn.line("v"), vim.fn.line(".")
  from, to = math.min(from, to), math.max(from, to)

  if mode == "n" then
    Snacks.image.doc.find(vim.api.nvim_get_current_buf(), function(matches)
      for _, img in ipairs(matches) do
        if is_cursor_in_range(cursor, img.range) then
          local key = get_key(img)
          if self.managed[key] then
            self.managed[key] = nil
            if self.placements[key] then
              self.placements[key]:close()
              self.placements[key] = nil
            end
          end
          return
        end
      end
    end, { from = from, to = to })
  else
    Snacks.image.doc.find(vim.api.nvim_get_current_buf(), function(matches)
      for _, img in ipairs(matches) do
        local key = get_key(img)
        if self.managed[key] then
          self.managed[key] = nil
          if self.placements[key] then
            self.placements[key]:close()
            self.placements[key] = nil
          end
        end
      end
    end, { from = from, to = to })
  end
end

-- Toggle showing the current image
function M:toggle_current()
  local cursor = vim.api.nvim_win_get_cursor(0)

  Snacks.image.doc.find(vim.api.nvim_get_current_buf(), function(matches)
    for _, img in ipairs(matches) do
      if is_cursor_in_range(cursor, img.range) then
        local key = get_key(img)
        if not self.managed[key] then
          self.managed[key] = img
          self:update()
        end
        if self.placements[key] and self.placements[key].opts.conceal then
          self.placements[key].opts.conceal = false
        end
        return
      end
    end
  end, { from = cursor[1], to = cursor[1] })
end

return M
