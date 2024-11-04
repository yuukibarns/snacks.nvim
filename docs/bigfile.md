# bigfile

<!-- docgen -->

## Config

```lua
---@class snacks.bigfile.Config
{
  size = 1.5 * 1024 * 1024, -- 1.5MB
  ---@param ev {buf: number, ft:string}
  behave = function(ev)
    vim.b.minianimate_disable = true
    vim.schedule(function()
      vim.bo[ev.buf].syntax = ev.ft
    end)
  end,
}
```

## Module

```lua
---@class snacks.bigfile
Snacks.bigfile = {}
```

### `Snacks.bigfile.setup()`

```lua
Snacks.bigfile.setup()
```
