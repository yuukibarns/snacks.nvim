---@class snacks.image.util
local M = {}

local dims = {} ---@type table<string, snacks.image.Size>

--- Get the dimensions of a PNG file
---@param file string
---@return snacks.image.Size
function M.dim(file)
  file = svim.fs.normalize(file)
  if dims[file] then
    return dims[file]
  end
  -- extract header with IHDR chunk
  local fd = assert(io.open(file, "rb"), "Failed to open file: " .. file)
  local header = fd:read(24) ---@type string
  fd:close()

  -- Check PNG signature
  assert(header:sub(1, 8) == "\137PNG\r\n\26\n", "Not a valid PNG file: " .. file)

  -- Extract width and height from the IHDR chunk
  local width = header:byte(17) * 16777216 + header:byte(18) * 65536 + header:byte(19) * 256 + header:byte(20)
  local height = header:byte(21) * 16777216 + header:byte(22) * 65536 + header:byte(23) * 256 + header:byte(24)
  dims[file] = { width = width, height = height }
  return dims[file]
end

---@param size snacks.image.Size
function M.pixels_to_cells(size)
  local terminal = Snacks.image.terminal.size()
  return M.norm({
    width = size.width / terminal.cell_width,
    height = size.height / terminal.cell_height,
  })
end

---@param size snacks.image.Size
---@return snacks.image.Size
function M.norm(size)
  return {
    width = math.max(1, math.ceil(size.width)),
    height = math.max(1, math.ceil(size.height)),
  }
end

---@param file string
---@param cells snacks.image.Size size in rows x columns
---@param opts? { full?: boolean, info?: snacks.image.Info }
function M.fit(file, cells, opts)
  opts = opts or {}
  local img_pixels ---@type snacks.image.Size
  if opts.info then
    img_pixels = {}
    if vim.g.neovide then
      img_pixels.height = opts.info.size.height * vim.g.neovide_scale_factor
      img_pixels.width = opts.info.size.width * vim.g.neovide_scale_factor
    else
      img_pixels.height = opts.info.size.height
      img_pixels.width = opts.info.size.width
    end
  else
    img_pixels = M.dim(file)
  end
  local img_cells = M.pixels_to_cells(img_pixels)

  local ret = vim.deepcopy(cells)
  -- if not opts.full then
  if img_cells.width <= cells.width and img_cells.height <= cells.height then
    return img_cells
  end
  ret.width = math.min(cells.width, img_cells.width)
  ret.height = math.min(cells.height, img_cells.height)
  -- end

  local scale = ret.width / ret.height
  local img_scale = img_cells.width / img_cells.height
  local fit_height = math.floor(ret.width / img_scale + 0.5)
  local fit_width = math.floor(ret.height * img_scale + 0.5)

  if ret.height == fit_height or ret.width == fit_width then
    -- Image fits exactly
  elseif img_scale > scale then
    -- Image is wider relative to height - fit to width
    ret.height = fit_height
  else
    -- Image is taller relative to width - fit to height
    ret.width = fit_width
  end
  return M.norm(ret)
end

-- Load macros from path to JSON file
---@param json_filepath string
---@return table<string, string>
local function load_macros(json_filepath)
  -- Read the file
  local file = io.open(json_filepath, 'r')
  if not file then
    vim.notify('Could not open macros file: ' .. json_filepath, vim.log.levels.ERROR)
    return {}
  end

  local content = file:read('*a')
  file:close()

  -- Parse with vim.json
  local ok, parsed = pcall(vim.json.decode, content)
  if not ok then
    vim.notify('Failed to parse macros JSON: ' .. parsed, vim.log.levels.ERROR)
    return {}
  end

  return parsed
end

-- Function to convert lua table of macros into latex commands
---@param macros table<string, string>
---@return string
local function macros_to_latex_commands(macros)
  local lines = {}

  for name, definition in pairs(macros) do
    if type(definition) == "table" then
      -- Handle array-style macros like ["\\bm", ["\\boldsymbol{#1}", 1]]
      local args = definition[2] or 0
      local cmd = definition[1]
      table.insert(lines, string.format("\\newcommand{\\%s}[%d]{%s}", name, args, cmd))
    else
      -- Handle simple string definitions
      table.insert(lines, string.format("\\newcommand{\\%s}{%s}", name, definition))
    end
  end

  return table.concat(lines, "\n")
end

-- Combine the above three functions
---@param json_filepath string
---@return string
function M.load_macros_to_latex_commands(json_filepath)
  local macros = load_macros(json_filepath)
  return macros_to_latex_commands(macros)
end

return M
