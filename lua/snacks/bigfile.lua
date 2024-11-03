---@class snacks.bigfile
local M = {}

---@class snacks.bigfile.Config
local defaults = {
  size = 1.5 * 1024 * 1024, -- 1.5MB
  ---@param ev {buf: number, ft:string}
  behave = function(ev)
    vim.b.minianimate_disable = true
    vim.schedule(function()
      vim.bo[ev.buf].syntax = ev.ft
    end)
  end,
}

function M.setup()
  local opts = Snacks.config.get("bigfile", defaults)

  vim.filetype.add({
    pattern = {
      [".*"] = {
        function(path, buf)
          return vim.bo[buf]
              and vim.bo[buf].filetype ~= "bigfile"
              and path
              and vim.fn.getfsize(path) > opts.size
              and "bigfile"
            or nil
        end,
      },
    },
  })

  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = vim.api.nvim_create_augroup("snacks_bigfile", { clear = true }),
    pattern = "bigfile",
    callback = function(ev)
      vim.api.nvim_buf_call(ev.buf, function()
        opts.behave({
          buf = ev.buf,
          ft = vim.filetype.match({ buf = ev.buf }) or "",
        })
      end)
    end,
  })
end

return M
