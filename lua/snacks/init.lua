---@class Snacks
---@field bigfile snacks.bigfile
---@field bufdelete snacks.bufdelete
---@field quickfile snacks.quickfile
---@field statuscolumn snacks.statuscolumn
---@field words snacks.words
---@field rename snacks.rename
---@field float snacks.float
local M = {}

setmetatable(M, {
  __index = function(t, k)
    ---@diagnostic disable-next-line: no-unknown
    t[k] = require("snacks." .. k)
    return t[k]
  end,
})

_G.Snacks = M

---@class snacks.Opts
---@field bigfile snacks.bigfile.Config | { enabled: boolean }
---@field quickfile { enabled: boolean }
---@field statuscolumn snacks.statuscolumn.Config  | { enabled: boolean }
---@field words snacks.words.Config
---@field float snacks.float.Config
local config = {
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
}

---@class snacks.Config: snacks.Opts
M.config = setmetatable({}, {
  __index = function(_, k)
    return config[k]
  end,
})

---@generic T: table
---@param snack string
---@param defaults T
---@return T
function M.config.get(snack, defaults)
  config[snack] = vim.tbl_deep_extend("force", {}, defaults, config[snack] or {})
  return config[snack]
end

---@param opts snacks.Opts?
function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})

  local group = vim.api.nvim_create_augroup("snacks", { clear = true })

  local events = {
    BufReadPre = { "bigfile" },
    BufReadPost = { "quickfile" },
    LspAttach = { "words" },
  }

  for event, snacks in pairs(events) do
    vim.api.nvim_create_autocmd(event, {
      group = group,
      once = true,
      callback = function()
        for _, snack in ipairs(snacks) do
          if M.config[snack].enabled then
            M[snack].setup()
          end
        end
      end,
    })
  end

  if M.config.statuscolumn.enabled then
    vim.o.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
  end
end

return M
