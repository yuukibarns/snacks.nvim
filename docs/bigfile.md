# 🍿 bigfile

<!-- docgen -->

## ⚙️ Config

```lua
---@class snacks.bigfile.Config
{
  notify = true,
  size = 1.5 * 1024 * 1024, -- 1.5MB
  ---@param ctx {buf: number, ft:string}
  setup = function(ctx)
    vim.b.minianimate_disable = true
    vim.schedule(function()
      vim.bo[ctx.buf].syntax = ctx.ft
    end)
  end,
}
```

## 📦 Module

```lua
---@class snacks.bigfile
Snacks.bigfile = {}
```

### `Snacks.bigfile.setup()`

```lua
Snacks.bigfile.setup()
```
