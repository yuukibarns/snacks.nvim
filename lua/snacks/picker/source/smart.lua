local M = {}

---@class snacks.picker
---@field smart fun(opts?: snacks.picker.smart.Config): snacks.picker.finder

---@param opts snacks.picker.smart.Config
---@type snacks.picker.finder
function M.smart(opts, filter)
  local done = {} ---@type table<string, boolean>
  local finder = Snacks.picker.config.finder(opts.finders or { "files", "buffers", "recent" })
  return require("snacks.picker.core.finder").wrap(finder, function(item)
    local path = Snacks.picker.util.path(item)
    if not path or done[path] then
      return false
    end
    done[path] = true
  end)(opts, filter)
end

return M
