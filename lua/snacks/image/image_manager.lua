---@module 'snacks.image.doc'
local doc = require("snacks.image.doc")

---@param src string
local function convert(src)
  local _convert = Snacks.image.convert.convert({ src = src })
  return _convert.file
end

---@class ImageManager
---@field buf integer
---@field imgs table<string, table<snacks.image.Placement>>
local ImageManager = {}
ImageManager.__index = ImageManager

--- Creates a new ImageManager instance.
---@param buf integer The buffer ID to manage images for.
---@return ImageManager
function ImageManager.new(buf)
  local self = setmetatable({}, ImageManager)
  self.buf = buf
  self.imgs = {} ---@type table<string, table<snacks.image.Placement>>
  return self
end

--- Retrieves images based on the current mode and cursor position.
---@return table<integer, table> A list of images.
function ImageManager:get_images()
  local mode = vim.fn.mode()
  local images = {}

  if mode == 'v' or mode == 'V' then
    local cursor_pos = vim.fn.getpos('.')
    local anchor_pos = vim.fn.getpos('v')

    local start_line = math.min(cursor_pos[2], anchor_pos[2])
    local end_line = math.max(cursor_pos[2], anchor_pos[2])
    local start_col = math.min(cursor_pos[3], anchor_pos[3]) - 1
    local end_col = math.max(cursor_pos[3], anchor_pos[3]) - 1

    local imgs = doc.find(vim.api.nvim_get_current_buf(), start_line, end_line + 1)

    for _, img in ipairs(imgs) do
      local range = img.range
      if range then
        if mode == "v" then
          if ((range[1] == start_line and range[2] >= start_col) or (range[1] > start_line)) and
              ((range[1] == end_line and range[2] <= end_col) or (range[1] < end_line)) or
              ((range[3] == start_line and range[4] >= start_col) or (range[3] > start_line)) and
              ((range[3] == end_line and range[4] <= end_col) or (range[3] < end_line)) or
              ((start_line == range[1] and start_col >= range[2]) or (start_line > range[1])) and
              ((end_line == range[3] and end_col <= range[4]) or (end_line < range[3])) then
            table.insert(images, { src = img.src, pos = img.pos, range = img.range })
          end
        elseif mode == "V" then
          if range[1] >= start_line and range[1] <= end_line or
              range[3] >= start_line and range[3] <= end_line or
              range[1] <= start_line and range[3] >= end_line then
            table.insert(images, { src = img.src, pos = img.pos, range = img.range })
          end
        end
      end
    end
  elseif mode == "n" then
    local cursor = vim.api.nvim_win_get_cursor(0)
    local imgs = doc.find(vim.api.nvim_get_current_buf(), cursor[1], cursor[1] + 1)
    for _, img in ipairs(imgs) do
      local range = img.range
      if range then
        if ((cursor[1] == range[1] and cursor[2] >= range[2]) or (cursor[1] > range[1])) and
            ((cursor[1] == range[3] and cursor[2] <= range[4]) or (cursor[1] < range[3])) then
          table.insert(images, { src = img.src, pos = img.pos, range = img.range })
          break
        end
      end
    end
  end

  return images
end

--- Opens images in the buffer.
function ImageManager:open()
  local found = {}
  for _, i in ipairs(doc.find(self.buf)) do
    if not found[i.src] then
      found[i.src] = {}
    end
    table.insert(found[i.src], i.pos)
  end

  -- Cleanup old images
  for src, img_list in pairs(self.imgs) do
    if not found[src] then
      for _, imag in ipairs(img_list) do
        imag:close()
      end
      self.imgs[src] = nil
    else
      for i, imag in ipairs(img_list) do
        local keep = false
        for _, pos in ipairs(found[src]) do
          if imag.opts.pos[1] == pos[1] and imag.opts.pos[2] == pos[2] then
            keep = true
            break
          end
        end
        if not keep then
          imag:close()
          table.remove(img_list, i)
        end
      end
    end
  end

  -- Add new images
  local images = self:get_images()
  for _, image in ipairs(images) do
    local src, pos, range = image.src, image.pos, image.range
    if src and pos then
      self.imgs[src] = self.imgs[src] or {}
      local exists = false

      for _, imag in ipairs(self.imgs[src]) do
        if imag.opts.pos[1] == pos[1] and imag.opts.pos[2] == pos[2] then
          exists = true
          break
        end
      end

      if not exists then
        local imag = Snacks.image.placement.new(
          self.buf,
          src,
          Snacks.config.merge({}, Snacks.image.config.doc, {
            pos = pos,
            range = range,
            inline = true
          })
        )
        table.insert(self.imgs[src], imag)
      end
    end
  end
end

--- Closes images in the buffer.
function ImageManager:close()
  local found = {}
  for _, i in ipairs(doc.find(self.buf)) do
    if not found[i.src] then
      found[i.src] = {}
    end
    table.insert(found[i.src], i.pos)
  end

  -- Cleanup old images
  for src, img_list in pairs(self.imgs) do
    if not found[src] then
      for _, imag in ipairs(img_list) do
        imag:close()
      end
      self.imgs[src] = nil
    else
      for i, imag in ipairs(img_list) do
        local keep = false
        for _, pos in ipairs(found[src]) do
          if imag.opts.pos[1] == pos[1] and imag.opts.pos[2] == pos[2] then
            keep = true
            break
          end
        end
        if not keep then
          imag:close()
          table.remove(img_list, i)
        end
      end
    end
  end

  local images = self:get_images()
  for _, image in ipairs(images) do
    local src, pos = image.src, image.pos
    if src and pos then
      if self.imgs[src] then
        for i, imag in ipairs(self.imgs[src]) do
          if imag.opts.pos[1] == pos[1] and imag.opts.pos[2] == pos[2] then
            imag:close()
            table.remove(self.imgs[src], i)
          end
        end
      end
    end
  end
end

--- Shows the images sources.
function ImageManager:show_src()
   local images = self:get_images()
   for _, image in ipairs(images) do
     local file = convert(image.src)
     vim.fn.setreg("+", file)
     vim.fn.setreg("*", file)
     vim.api.nvim_echo({{file .. " " .. "copied to clipboard"}}, true, {})
   end
end

return ImageManager
