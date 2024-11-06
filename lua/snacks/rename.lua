---@hide
---@class snacks.rename
---@overload fun()
local M = setmetatable({}, {
  __call = function(t)
    return t.rename()
  end,
})

local uv = vim.uv or vim.loop

---@param path string
function M.realpath(path)
  return vim.fs.normalize(uv.fs_realpath(path) or path)
end

function M.rename()
  local buf = vim.api.nvim_get_current_buf()
  local old = assert(M.realpath(vim.api.nvim_buf_get_name(buf)))
  local root = assert(M.realpath(uv.cwd() or "."))

  if old:find(root, 1, true) ~= 1 then
    root = vim.fn.fnamemodify(old, ":p:h")
  end

  local extra = old:sub(#root + 2)

  vim.ui.input({
    prompt = "New File Name: ",
    default = extra,
    completion = "file",
  }, function(new)
    if not new or new == "" or new == extra then
      return
    end
    new = vim.fs.normalize(root .. "/" .. new)
    vim.fn.mkdir(vim.fs.dirname(new), "p")
    M.on_rename(old, new, function()
      vim.fn.rename(old, new)
      vim.cmd.edit(new)
      vim.api.nvim_buf_delete(buf, { force = true })
      vim.fn.delete(old)
    end)
  end)
end

---@param from string
---@param to string
---@param rename? fun()
function M.on_rename(from, to, rename)
  local changes = { files = { {
    oldUri = vim.uri_from_fname(from),
    newUri = vim.uri_from_fname(to),
  } } }

  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    if client.supports_method("workspace/willRenameFiles") then
      local resp = client.request_sync("workspace/willRenameFiles", changes, 1000, 0)
      if resp and resp.result ~= nil then
        vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
      end
    end
  end

  if rename then
    rename()
  end

  for _, client in ipairs(clients) do
    if client.supports_method("workspace/didRenameFiles") then
      client.notify("workspace/didRenameFiles", changes)
    end
  end
end

return M
