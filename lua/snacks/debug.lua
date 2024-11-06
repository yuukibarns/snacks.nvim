---@class snacks.debug
---@hide
---@overload fun(...)
local M = setmetatable({}, {
  __call = function(t, ...)
    return t.inspect(...)
  end,
})

-- Show a notification with a pretty printed dump of the object(s)
-- with lua treesitter highlighting and the location of the caller
function M.inspect(...)
  local len = select("#", ...) ---@type number
  local obj = { ... } ---@type unknown[]
  local caller = debug.getinfo(1, "S")
  for level = 2, 10 do
    local info = debug.getinfo(level, "S")
    if
      info
      and info.source ~= caller.source
      and info.what == "Lua"
      and info.source ~= "lua"
      and info.source ~= "@" .. vim.env.MYVIMRC
    then
      caller = info
      break
    end
  end
  local title = "Debug: " .. vim.fn.fnamemodify(caller.source:sub(2), ":~:.") .. ":" .. caller.linedefined
  Snacks.notify.warn(vim.inspect(len == 1 and obj[1] or len > 0 and obj or nil), { title = title, ft = "lua" })
end

-- Show a notification with a pretty backtrace
function M.backtrace()
  local trace = {}
  for level = 2, 20 do
    local info = debug.getinfo(level, "Sln")
    if info and info.what == "Lua" and info.source ~= "lua" then
      local line = "- `" .. vim.fn.fnamemodify(info.source:sub(2), ":p:~:.") .. "`:" .. info.currentline
      if info.name then
        line = line .. " _in_ **" .. info.name .. "**"
      end
      table.insert(trace, line)
    end
  end
  Snacks.notify.warn(#trace > 0 and (table.concat(trace, "\n")) or "", { title = "Backtrace" })
end

-- Very simple function to profile a lua function.
-- * **flush**: set to `true` to use `jit.flush` in every iteration.
-- * **count**: defaults to 100
---@param fn fun()
---@param opts? {count?: number, flush?: boolean}
function M.profile(fn, opts)
  opts = vim.tbl_extend("force", { count = 100, flush = true }, opts or {})
  local start = vim.uv.hrtime()
  for _ = 1, opts.count, 1 do
    if opts.flush then
      jit.flush(fn, true)
    end
    fn()
  end
  Snacks.notify(((vim.uv.hrtime() - start) / 1e6 / opts.count) .. "ms")
end

return M
